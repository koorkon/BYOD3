pipeline {
    agent any
    environment {
        TF_VAR_FILE = "./vars/dev.tfvars" 
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Provision & Capture') {
            steps {
                sh "terraform init"
                sh "terraform apply -auto-approve -var-file=./vars/dev.tfvars"
                
                script {
                    env.INSTANCE_IP = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
                    env.INSTANCE_ID = sh(script: "terraform output -raw instance_id", returnStdout: true).trim()
                }
            }
        }

        stage('Dynamic Inventory') {
            steps {
                sh "echo '[splunk_servers]\n${env.INSTANCE_IP} ansible_user=ubuntu' > dynamic_inventory.ini"
                sh "cat dynamic_inventory.ini" 
            }
        }

        stage('AWS Health Verification') {
            steps {
                echo "Waiting for instance ${env.INSTANCE_ID}..."
                sh "aws ec2 wait instance-status-ok --instance-ids ${env.INSTANCE_ID}"
            }
        }

        stage('Splunk Install & Test') {
            steps {
                ansiblePlaybook(playbook: 'playbooks/splunk.yml', inventory: 'dynamic_inventory.ini')
                ansiblePlaybook(playbook: 'playbooks/test-splunk.yml', inventory: 'dynamic_inventory.ini')
            }
        }

        stage('Validate Destroy') {
            steps {
                input message: "Infrastructure verified. Proceed to destroy?"
            }
        }

        stage('Destroy') {
            steps {
                sh "terraform destroy -auto-approve -var-file=./vars/dev.tfvars"
            }
        }
    }
    post {
        always {
            sh "rm -f dynamic_inventory.ini"
        }
        failure {
            sh "terraform destroy -auto-approve -var-file=./vars/dev.tfvars"
        }
        aborted {
            sh "terraform destroy -auto-approve -var-file=./vars/dev.tfvars"
        }
    }
}
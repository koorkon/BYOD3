pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS = '-no-color'
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        SSH_CRED_ID           = 'my-ssh-key-id' 
    }

    stages {
        stage('Terraform Init & Verify') {
            steps {
                sh 'terraform init'
                script {
                    echo "Verifying dev.tfvars content..."
                    sh "cat dev.tfvars"
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo "Generating execution plan using dev.tfvars..."
                    sh "terraform plan -var-file=dev.tfvars -out=tfplan"
                }
            }
        }

        stage('Validate Apply') {
            steps {
                input message: "Review the plan in the console. Do you want to proceed with the Apply?", 
                      ok: "Confirm Deployment"
            }
        }

        stage('Terraform Apply') {
            steps {
                sh "terraform apply -auto-approve tfplan"
            }
        }
    }
    
    post {
        failure {
            echo "Terraform deployment failed. Please check the logs."
        }
    }
}
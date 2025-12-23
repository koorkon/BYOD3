pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_CLI_ARGS      = '-no-color'
        
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        SSH_CRED_ID           = 'my-ssh-key-id'
    }
    stages {
        stage('TInit & Inspect') {
            steps {
                sh 'terraform init'
                script {
                    echo "Checking configuration for branch: ${env.BRANCH_NAME}"
                    sh "cat ${env.BRANCH_NAME}.tfvars"
                }
            }
    }
}
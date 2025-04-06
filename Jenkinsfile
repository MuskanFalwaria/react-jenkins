pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal-1'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'webapijenkins98282363'
        TERRAFORM_PATH = '"C:\\Users\\ASUS\\Downloads\\terraform_1.11.3_windows_amd64\\terraform.exe"'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/MuskanFalwaria/react-jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat '"%TERRAFORM_PATH%" -chdir=terraform init'
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                bat '"%TERRAFORM_PATH%" -chdir=terraform plan -out=tfplan'
                bat '"%TERRAFORM_PATH%" -chdir=terraform apply -auto-approve tfplan'
            }
        }

        stage('Build React App') {
            steps {
                dir('client') { // or the correct subdirectory name
                    bat 'npm install'
                    bat 'npm run build'
                }
            }
        }


        stage('Deploy to Azure') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                    bat 'powershell Compress-Archive -Path build/* -DestinationPath ./build.zip -Force'
                    bat 'az webapp deploy --resource-group %RESOURCE_GROUP% --name %APP_SERVICE_NAME% --src-path ./build.zip --type zip'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}

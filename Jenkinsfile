pipeline {
  agent any

  environment {
    REACT_APP_DIR = 'my-app'
    TERRAFORM_DIR = 'terraform'
    AZURE_WEBAPP_NAME = 'webapijenkins9828236345'
    AZURE_RG = 'myResourceGroup'
    AZURE_PLAN = 'appserviceplanmuskan'
    TERRAFORM_PATH = '"C:\\Users\\ASUS\\Downloads\\terraform_1.11.3_windows_amd64\\terraform.exe"'

  }

  stages {
    stage('Install Dependencies') {
      steps {
        dir("${REACT_APP_DIR}") {
          bat 'npm install'
        }
      }
    }

    stage('Build React App') {
      steps {
        dir("${REACT_APP_DIR}") {
          bat 'npm run build'
        }
      }
    }

    stage('Terraform Init') {
            steps {
                bat '"%TERRAFORM_PATH%" -chdir=terraform init'
            }
        }


    stage('Terraform Apply') {
    steps {
        dir('terraform') {
            bat '"C:\\Users\\ASUS\\Downloads\\terraform_1.11.3_windows_amd64\\terraform.exe" apply -auto-approve'
        }
    }
}


    stage('Zip Build Folder') {
      steps {
        dir("${REACT_APP_DIR}\\build") {
          bat 'powershell Compress-Archive -Path * -DestinationPath ..\\build.zip'
        }
      }
    }

    stage('Deploy to Azure App Service') {
      steps {
        dir("${REACT_APP_DIR}") {
          bat """
            az webapp deployment source config-zip ^
              --resource-group %AZURE_RG% ^
              --name %AZURE_WEBAPP_NAME% ^
              --src build.zip
          """
        }
      }
    }
  }

  post {
    success {
      echo "✅ Deployment completed successfully!"
    }
    failure {
      echo "❌ Something went wrong."
    }
  }
}

pipeline {
  agent any

  environment {
    DOCKERHUB_USER = 'vaibhavgumalwad'
    IMAGE_NAME = 'myapp'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        script {
          env.GIT_COMMIT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        }
      }
    }

    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh """
          docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
          chmod +x scripts/build_and_push.sh
          ./scripts/build_and_push.sh ${GIT_COMMIT}
          """
        }
      }
    }

    stage('Deploy with Ansible') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
          sh """
            export ANSIBLE_HOST_KEY_CHECKING=False
            ansible-playbook -i ansible/hosts.ini ansible/deploy.yml \
              --private-key "$SSH_KEY" -u "$SSH_USER" \
              -e git_commit=${GIT_COMMIT}
          """
        }
      }
    }
  }

  post {
    failure {
      echo "❌ Pipeline failed"
    }
    success {
      echo "✅ Deployed to EC2 Instance"
    }
  }
}

pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    APP_DIR        = "MyApp"
    IMAGE_NAME     = "angular-local"
    CONTAINER_NAME = "angularapp"
    HOST_PORT      = "8000"
    CONTAINER_PORT = "80"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Docker Image') {
      steps {
        dir("${APP_DIR}") {
          script {
            env.IMAGE_TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          }
          sh """
            docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .
          """
        }
      }
    }

    stage('Deploy Container') {
      steps {
        sh """
          docker rm -f ${CONTAINER_NAME} || true
          docker run -d --restart=always --name ${CONTAINER_NAME} \
            -p ${HOST_PORT}:${CONTAINER_PORT} \
            ${IMAGE_NAME}:${IMAGE_TAG}
        """
      }
    }
  }
}

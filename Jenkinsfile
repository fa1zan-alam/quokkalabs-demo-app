pipeline {
    agent any
    environment {
        GIT_REPO_URL = "https://github.com/fa1zan-alam/quokkalabs-demo-app.git"

        APP_NAME = "quokkalabs-demo-app"
        APP_VERSION = "v0.1.$BUILD_NUMBER"
        APP_IMAGE = "faiz637/${APP_NAME}:${APP_VERSION}"

        DOCKER_REG_URL = "https://index.docker.io/v1/"

    }
    stages {
        stage('Code Checkout') {
            steps {
                // source code checkout
                git branch: 'main', credentialsId: 'github-cred', url: "${GIT_REPO_URL}"
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                //build and push docker image to docker registry
                sh "echo 'this is docker image build stage"
                script {
                    appImage = docker.build("${APP_IMAGE}")
                    docker.withRegistry("${DOCKER_REG_URL}", 'dockerhub-cred') {
                        appImage.push()
                        appImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy App') {
            steps {
                //deploy app
                sh "echo 'this is deployment stage'"
                script {
                    docker compose -f <(APP_IMAGE="${APP_IMAGE}" envsubst <docker-compose.yml) up -d                    
                }
            }
        }
    }
}

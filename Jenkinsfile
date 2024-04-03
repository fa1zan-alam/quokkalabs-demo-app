pipeline {
    agent any
    environment {
        GIT_REPO_URL = "https://github.com/fa1zan-alam/quokkalabs-demo-app.git"

        APP_NAME = "quokkalabs-demo-app"
        APP_VERSION = "v0.1.$BUILD_NUMBER"
        APP_IMAGE = "faiz637/${APP_NAME}:${APP_VERSION}"

        DOCKER_REG_URL = "https://index.docker.io/v1/"
        DOCKER_HOST_TCP_URL = "tcp://172.31.84.85:4243"

        MAIL_TO = """
        ananda.yashaswi@quokkalabs.com,
        faizualam637@gmail.com
        """
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
                sh "echo 'this is docker image build stage'"
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
                    docker.withServer("${DOCKER_HOST_TCP_URL}") {
                        sh '''
                        sed  -i "s|image:.*|image: ${APP_IMAGE}|g" docker-compose.yml
                        docker compose -f docker-compose.yml up -d
                        '''
                    }
                }
            }
        }
    }
    post {
         always {
            echo 'Sending Job status via email'
            mail to: "${MAIL_TO}",
            subject: "[${currentBuild.currentResult}]: Jenkins Job | ${env.JOB_NAME} | #${env.BUILD_NUMBER}",
            body: """
            Please find job details below:

            Job Name    : ${env.JOB_NAME}
            Job Number  : ${env.BUILD_NUMBER}
            Job Status  : ${currentBuild.result}

            Note: This is an autogenerated email. Please visit JOB URL ${env.BUILD_URL} for more details.
            """
        }
    }
}

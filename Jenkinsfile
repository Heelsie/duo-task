pipeline {
    agent any
    stages {

        stage('Build') {
            steps {
                sh '''
                docker build -t heelsie/duo-deploy-flask:latest -t heelsie/duo-deploy-flask:v${BUILD_NUMBER} .
                docker build -t heelsie/flask-nginx:latest -t heelsie/flask-nginx:v${BUILD_NUMBER} .
                '''
            }
        }

        stage('Push') {
            steps {
                sh '''
                docker push heelsie/duo-deploy-flask:latest
                docker push heelsie/duo-deploy-flask:v${BUILD_NUMBER}
                docker push heelsie/flask-nginx:latest
                docker push heelsie/flask-nginx:v${BUILD_NUMBER}
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                kubectl apply -f ./kubernetes
                kubectl set image deployment/flask-deployment flask-container=heelsie/duo-deploy-flask:v${BUILD_NUMBER}
                kubectl set image deployment/nginx-deployment nginx-container=heelsie/flask-nginx:v${BUILD_NUMBER}
                '''
            }
        }

        stage('CleanUp') {
            steps {
                sh '''
                docker system prune -f 
                '''
            }
        }
    }

}
pipeline {
    agent any
    stages {
        stage('Init') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/master") {
                        sh '''
                        kubectl create namespace prod || echo "Namespace prod already exists"
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev") {
                        sh '''
                        kubectl create namespace dev || echo "Namespace dev already exists"
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }
        
         stage('Build') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/master") {
                        sh '''
                        docker build -t heelsie/duo-deploy-flask:latest -t heelsie/duo-deploy-flask:prod-v${BUILD_NUMBER} .
                        docker build -t heelsie/flask-nginx:latest -t heelsie/flask-nginx:prod-v${BUILD_NUMBER} .
                        '''
                    } else if (env.GIT_BRANCH == "origin/dev") {
                        sh '''
                        docker build -t heelsie/duo-deploy-flask:latest -t heelsie/duo-deploy-flask:dev-v${BUILD_NUMBER} .
                        docker build -t heelsie/flask-nginx:latest -t heelsie/flask-nginx:dev-v${BUILD_NUMBER} .
                        '''
                    } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('Push') {
            steps {
                script {
                    if (env.GIT_BRANCH == "origin/master") {
                sh '''
                docker push heelsie/duo-deploy-flask:latest
                docker push heelsie/duo-deploy-flask:prod-v${BUILD_NUMBER}
                docker push heelsie/flask-nginx:latest
                docker push heelsie/flask-nginx:prod-v${BUILD_NUMBER}
                '''
            
            } else if (env.GIT_BRANCH == "origin/dev") {
                sh '''
                docker push heelsie/duo-deploy-flask:latest
                docker push heelsie/duo-deploy-flask:dev-v${BUILD_NUMBER}
                docker push heelsie/flask-nginx:latest
                docker push heelsie/flask-nginx:dev-v${BUILD_NUMBER}
                '''
                } else {
                        sh '''
                        echo "Branch not recognised"
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                    script {
                        if (env.GIT_BRANCH == "origin/master") {
                    sh '''
                    kubectl apply -n prod -f ./kubernetes
                    kubectl set image deployment/flask-deployment flask-container=heelsie/duo-deploy-flask:v${BUILD_NUMBER} -n prod
                    kubectl set image deployment/nginx-deployment nginx-container=heelsie/flask-nginx:prod-v${BUILD_NUMBER} -n prod
                    '''
                    } else if (env.GIT_BRANCH == "origin/dev") {
                        sh '''
                    kubectl apply -n dev -f ./kubernetes
                    kubectl set image deployment/flask-deployment flask-container=heelsie/duo-deploy-flask:v${BUILD_NUMBER} -n dev
                    kubectl set image deployment/nginx-deployment nginx-container=heelsie/flask-nginx:dev-v${BUILD_NUMBER} -n dev
                    '''
                    } else {
                        sh '''
                            echo "Branch not recognised"
                            '''
                    }
                }
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
pipeline {
    agent any

    tools {
        nodejs 'node20'  // Le nom que tu as mis dans l'étape 3
    }

    environment {
        IMAGE_NAME = 'khalilessouri/student-management-front'
        K8S_NAMESPACE = 'devops'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build') {
            steps {
                // Installe les dépendances et construit le projet
                sh 'npm install'
                sh 'npm run build -- --configuration production'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                       echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                       docker push ${IMAGE_NAME}:latest
                       docker logout
                   '''
               }
           }
       }

       stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'k8s-confi', variable: 'KUBECONFIG')]) {
                    script {
                       sh "kubectl apply -f STUDENT-MANAGAMENET-FRONT/k8s/angular-deployment.yaml -n ${K8S_NAMESPACE}"
                       sh "kubectl rollout restart deployment/angular-app -n ${K8S_NAMESPACE}"
                   }
                }
           }
       }
    }
}
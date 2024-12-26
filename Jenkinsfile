pipeline {
    agent {
        docker {
            image 'maven:3.8.8-openjdk-11' // Maven image with Java 11
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
        }
    }

    environment {
        // Replace with Jenkins credentials IDs
        DOCKER_CREDENTIALS_ID = 'dockerhub-cred'
        GITHUB_CREDENTIALS_ID = 'github-cred'
        // DOCKER_IMAGE = 'your-dockerhub-username/your-repository'
		DOCKER_IMAGE = 'mushfiqueghayas/project-5:${BUILD_NUMBER}'
    }

    stages {
        stage('Checkout') {
            steps {
                // Fetch code from GitHub using credentials
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Mushfiqueghayas/project-5.git',
                        credentialsId: GITHUB_CREDENTIALS_ID
						
                    ]]
                ])
            }
        }

        stage('Build') {
            steps {
                // Clean and build the Java project using Maven
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                // Build a Docker image using the Dockerfile
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Docker Push') {
            steps {
                // Log in to Docker Hub and push the image
                withDockerRegistry([credentialsId: DOCKER_CREDENTIALS_ID]) {
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Deploy') {
            steps {
                // Stop and remove any existing container, then run the new one
                sh '''
                docker stop my-java-app || true
                docker rm my-java-app || true
                docker run -d --name my-java-app -p 8081:8080 ${DOCKER_IMAGE}
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

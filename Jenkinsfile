node {
    // Define environment variables
    def DOCKER_IMAGE = "hello-world"
    def DOCKER_REGISTRY = "http://localhost:8081/repository/hello-world/"
    def NEXUS_CREDENTIALS = credentials('nexus') 
    def GIT_REPO = 'https://github.com/chiragaiml21/jenkins-cicd.git'

    // Checkout the Git repository
    stage('Clone repository') {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: GIT_REPO]]])
    }

    // Build Docker image
    stage('Build Docker image') {
        try {
            sh "docker build -t ${DOCKER_IMAGE}:latest -f Dockerfile ."
        } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            throw e
        }
    }

    // Push Docker image to Nexus
    stage('Push Docker image to Nexus') {
        try {
            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: NEXUS_CREDENTIALS, usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD']]) {
                sh "docker login -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD} ${DOCKER_REGISTRY}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            throw e
        }
    }

    // Deploy to Minikube
    stage('Deploy to Minikube') {
        try {
            sh 'kubectl apply -f deployment.yaml'
        } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            throw e
        }
    }
}

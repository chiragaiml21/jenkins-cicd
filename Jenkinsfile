node {
    def DOCKER_IMAGE = "hello-world"
    def DOCKER_REGISTRY = "localhost:8082/repository/hello-world"
    def NEXUS_CREDENTIALS = credentials('nexus') 
    def GIT_REPO = 'https://github.com/chiragaiml21/jenkins-cicd.git'

    stage('Clone repository') {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: GIT_REPO]]])
    }

    stage('Build Docker image') {
        docker.build("${DOCKER_IMAGE}:latest", "-f Dockerfile .")
    }

    stage('Push Docker image to Nexus') {
        script {
            docker.withRegistry("http://${DOCKER_REGISTRY}", "${NEXUS_CREDENTIALS}") {
                docker.image("${DOCKER_IMAGE}:latest").push()
            }
        }
    }

    stage('Deploy to Minikube') {
        script {
            sh 'kubectl apply -f deployment.yaml'
        }
    }
}

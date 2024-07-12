node {
    def DOCKER_IMAGE = "hello-world"
    def DOCKER_REGISTRY = "localhost:8082/repository/hello-world"
    def NEXUS_CREDENTIALS = 'nexus'
    def GIT_REPO = 'https://github.com/chiragaiml21/jenkins-cicd.git'

    stage('Clone repository') {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: GIT_REPO]]])
    }

    stage('Build Docker image') {
        bat 'docker build -t hello-world:latest -f Dockerfile .'
        echo "Build Successful......"
    }

    stage('Push Docker image to Nexus') {
        docker.withRegistry("http://${DOCKER_REGISTRY}", "${NEXUS_CREDENTIALS}") {
            docker.image("${DOCKER_IMAGE}:latest").push()
        }
        echo "Successfully pushed to Nexus repository"
    }

    stage('Deploy to Minikube') {
        withKubeConfig([credentialsId: 'kubernetes', serverUrl: 'https://127.0.0.1:57334']) {
            bat "kubectl apply -f deployment.yaml --validate=false"
        }

        
        echo "Deployment Successful....."
    }
}

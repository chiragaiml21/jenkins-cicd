node {
    def DOCKER_IMAGE = "poc-helloworld"
    def DOCKER_REGISTRY = "localhost:8082/repository/poc-helloworld"
    def NEXUS_CREDENTIALS = 'nexus'
    def GIT_REPO = 'https://github.com/chiragaiml21/jenkins-cicd.git'
    def KUBE_CONFIG_PATH = "C:\\Users\\Chirag\\.kube\\config"

    stage('Clone repository') {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: GIT_REPO]]])
    }

    stage('Build Docker image') {
        bat 'docker build -t poc-helloworld:latest -f Dockerfile .'
        echo "Build Successful......"
    }

    stage('Push Docker image to Nexus') {
        docker.withRegistry("http://${DOCKER_REGISTRY}", "${NEXUS_CREDENTIALS}") {
            docker.image("${DOCKER_IMAGE}:latest").push()
        }
        echo "Successfully pushed to Nexus repository"
    }

    stage('Deploy to Minikube') {
        withEnv(["KUBECONFIG=${KUBE_CONFIG_PATH}"]) {
            bat "kubectl version"
            bat "kubectl apply -f deployment.yaml"
        }
        echo "Deployment Successful....."
    }
}

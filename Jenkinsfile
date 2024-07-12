node {
    def DOCKER_IMAGE = "hello-world"
    def DOCKER_REGISTRY = "localhost:8082/repository/hello-world"
    def NEXUS_CREDENTIALS = 'nexus'
    def GIT_REPO = 'https://github.com/chiragaiml21/jenkins-cicd.git'
    def KUBE_CONFIG = '''apiVersion: v1
clusters:
- cluster:
    certificate-authority: C:\\Users\\Chirag\\.minikube\\ca.crt
    extensions:
    - extension:
        last-update: Fri, 12 Jul 2024 22:30:56 IST
        provider: minikube.sigs.k8s.io
        version: v1.33.1
      name: cluster_info
    server: https://127.0.0.1:51520
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Fri, 12 Jul 2024 22:30:56 IST
        provider: minikube.sigs.k8s.io
        version: v1.33.1
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: C:\\Users\\Chirag\\.minikube\\profiles\\minikube\\client.crt
    client-key: C:\\Users\\Chirag\\.minikube\\profiles\\minikube\\client.key'''

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
        withKubeConfig([credentialsId: 'kubernetes', serverUrl: 'https://127.0.0.1:51520', config: KUBE_CONFIG]) {
            bat "kubectl apply -f deployment.yaml --validate=false"
        }
        echo "Deployment Successful....."
    }
}

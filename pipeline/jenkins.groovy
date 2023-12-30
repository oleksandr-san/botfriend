pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm', 'arm64'], description: 'Pick ARCH')
    }
    stages {
        stage('test') {
            steps {
                echo "make test"
                sh "make test"
            }
        }
        stage('build') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"
                sh "make build TARGETOS=${params.OS} TARGETARCH=${params.ARCH}"
            }
        }
        stage('image') {
            steps {
                echo "Build image for platform ${params.OS}"
                echo "Build image for arch: ${params.ARCH}"

                sh "make image TARGETOS=${params.OS} TARGETARCH=${params.ARCH} REGISTRY=oleksandran"
            }
        }
        stage('push') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub') {
                        sh "make push TARGETOS=${params.OS} TARGETARCH=${params.ARCH} REGISTRY=oleksandran"
                    }
                }
            }
        }
    }
}
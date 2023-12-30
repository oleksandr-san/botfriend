pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm', 'arm64'], description: 'Pick ARCH')
    }
    stages {
        stage('build') {
            steps {
                echo "make build"
                make build
            }
        }
        stage('test') {
            steps {
                echo "make test"
                make test
            }
        }
        stage('image') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"

                sh "make image TARGETOS=${params.OS} TARGETARCH=${params.ARCH}"
            }
        }
        stage('push') {
            steps {
                echo "make push"
                make push
            }
        }
    }
}
pipeline {
     agent {
        label 'amazon-slave'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/satyadarling/Testing.git'
            }
        }
    }
}


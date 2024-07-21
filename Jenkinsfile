pipeline {
    agent {
        label 'amazon-slave'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/satyadarling/Testing.git'
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                script {
                    dir('terraform') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'AWS_KEY',
                            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            sh '''
                              terraform init
                              terraform apply -auto-approve
                            '''
                        }
                    }
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                dir('ansible') {
                    script {
                        sh './generate_inventory.sh'
                    }
                }
            }
        }

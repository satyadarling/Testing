pipeline {
    agent {
        label 'amazon-slave'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_KEY').accessKey
        AWS_SECRET_ACCESS_KEY = credentials('AWS_KEY').secretKey
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
                    dir('my_testing/terraform') {
                        sh '''
                          terraform init
                          terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                dir('my_testing/ansible') {
                    script {
                        sh './generate_inventory.sh'
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('my_testing/ansible') {
                    script {
                        sh '''
                          ansible-playbook playbook.yml -i inventory.txt
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                dir('my_testing/terraform') {
                    sh '''
                      terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}

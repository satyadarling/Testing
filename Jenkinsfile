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
                    dir('test/terraform') {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_KEY']]) {
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
                dir('Testing/ansible') {
                    script {
                        sh './generate_inventory.sh'
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                dir('Testing/ansible') {
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
                dir('Testing/terraform') {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_KEY']]) {
                        sh '''
                          terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }
    }
}

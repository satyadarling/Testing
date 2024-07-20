pipeline {
    agent {
        label 'amazon-slave'
    }


        stage('Terraform Init and Apply') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_KEY']]) {
                        dir('Testing/terraform') {
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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    dir('Testing/terraform') {
                        sh '''
                          if [ -x "$(command -v terraform)" ]; then
                            terraform destroy -auto-approve
                          else
                            echo "Terraform is not installed."
                          fi
                        '''
                    }
                }
            }
        }
    }
}

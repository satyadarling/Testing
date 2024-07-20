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

        stage('Install Git and Terraform') {
            steps {
                script {
                    sh '''
                      # Install Git if not already installed
                      if ! [ -x "$(command -v git)" ]; then
                        echo "Git not found. Installing..."
                        sudo yum update -y
                        sudo yum install -y git
                      else
                        echo "Git is already installed."
                      fi

                      # Install Terraform if not already installed
                      if ! [ -x "$(command -v terraform)" ]; then
                        echo "Terraform not found. Installing..."
                        curl -LO https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip
                        unzip terraform_1.0.0_linux_amd64.zip
                        sudo mv terraform /usr/local/bin/
                        sudo chmod +x /usr/local/bin/terraform
                      else
                        echo "Terraform is already installed."
                      fi
                    '''
                }
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                script {
                    dir('terraform') {
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                            sh '''
                              terraform init
                              terraform apply -auto-approve
                            '''
                        }
                    }
                }
            }
        }

        stage('Install Ansible') {
            steps {
                script {
                    sh '''
                      if ! [ -x "$(command -v ansible)" ]; then
                        echo "Ansible not found. Installing..."
                        sudo yum update -y
                        sudo amazon-linux-extras install ansible2 -y
                      else
                        echo "Ansible is already installed."
                      fi
                    '''
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

        stage('Run Ansible Playbook') {
            steps {
                dir('ansible') {
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
                dir('terraform') {
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

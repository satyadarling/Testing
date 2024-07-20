pipeline {
    agent {
        label 'amazon-slave'
    }

    environment {
        TF_VAR_aws_access_key = credentials('AWS_ACCESS_KEY_ID')
        TF_VAR_aws_secret_key = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://your-repo-url.git'
            }
        }

        stage('Install Terraform') {
            steps {
                script {
                    sh '''
                      if ! [ -x "$(command -v terraform)" ]; then
                        echo "Terraform not found. Installing..."
                        curl -LO https://releases.hashicorp.com/terraform/1.0.0/terraform_1.0.0_linux_amd64.zip
                        unzip terraform_1.0.0_linux_amd64.zip
                        sudo mv terraform /usr/local/bin/
                      else
                        echo "Terraform is already installed."
                      fi
                    '''
                }
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                dir('terraform') {
                    script {
                        sh '''
                          terraform init
                          terraform apply -auto-approve
                        '''
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
                        sudo apt update
                        sudo apt install -y ansible
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
            dir('terraform') {
                script {
                    sh '''
                      terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}


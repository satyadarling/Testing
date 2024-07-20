pipeline {
    agent {
        label 'amazon-slave'
    }

    environment {
        TF_VAR_aws_access_key = credentials('aws-credentials').accessKey
        TF_VAR_aws_secret_key = credentials('aws-credentials').secretKey
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/satyadarling/Testing.git'
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
                    withCredentials([aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        dir('terraform') {
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
                withCredentials([aws(credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform') {
                        sh '''
                          terraform destroy -auto-approve
                        '''
                    }
                }
            }
        }
    }
}

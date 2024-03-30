pipeline {
    agent { 
        node { 
            label 'AGENT-1' 
            } 
        }
    options {
        ansiColor('xterm')
        timeout(time: 1, unit: 'HOURS')
        disableConcurrentBuilds()
    }
    // Build
    stages {
        stage('vpc') { 
            steps {
                sh """
                   cd 01-vpc
                   terraform init -reconfigure
                   terraform apply -auto-approve
                """
            }
        }
        stage('sg') { 
            steps {
                sh """
                   cd 02-sg
                   terraform init -reconfigure
                   terraform apply -auto-approve
                """
            }
        }
        stage('vpn') { 
            steps {
                sh """
                   cd 03-vpn
                   terraform init -reconfigure
                   terraform apply -auto-approve
                """
            }
        }
        stage('DB & ALB') { 
            parallel {
                stage('DB') {
                    steps {
                        sh """
                          cd 04-databases
                          terraform init -reconfigure
                          terraform apply -auto-approve
                        """                       
                    }
                }
                stage('APP-ALB') {
                    steps {
                        sh """
                          cd 05-app-alb
                          terraform init -reconfigure
                          terraform apply -auto-approve
                        """ 
                    }
                } 
            }
        }
    }
    // Post Build
    post { 
        always { 
            echo 'I will always say Hello again!'
        }
        failure { 
            echo 'I will run when the job has failed!'
        }
        success { 
            echo 'I will run when the job is success!'
        }
        aborted { 
            echo 'I will run when the job is aborted manually!'
        }
    }
}
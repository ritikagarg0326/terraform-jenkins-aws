pipeline {

    agent any

    environment {
        AWS_REGION = 'us-east-1'

        TF_VAR_ami_id = credentials('TF_VAR_AMI_ID')
        TF_VAR_key_name = credentials('TF_VAR_KEY_NAME')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt -check -recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Show Jenkins URLs') {
            steps {
                sh '''
                    echo "=========================================="
                    echo "       JENKINS DEPLOYMENT SUCCESSFUL"
                    echo "=========================================="

                    echo ""
                    echo "Jenkins through Application Load Balancer:"
                    echo "http://$(terraform output -raw load_balancer_dns)"

                    echo ""
                    echo "Jenkins EC2 Public IP:"
                    echo "http://$(terraform output -raw jenkins_public_ip):8080"

                    echo ""
                    echo "Jenkins URL:"
                    terraform output -raw jenkins_url

                    echo ""
                    echo "Jenkins EC2 Instance ID:"
                    terraform output -raw jenkins_instance_id

                    echo ""
                    echo "=========================================="
                '''
            }
        }
    }

    post {

        success {
            echo 'Terraform deployment completed successfully!'
        }

        failure {
            echo 'Terraform pipeline failed!'
        }

        always {
            archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
        }
    }
}
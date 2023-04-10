pipeline {
agent any 
tools {
maven 'MVN_HOME'
}

stages {
stage("Git Checkout"){
steps{
git 'https://github.com/gururajkotyal/staragile-healthcare_final-project.git'
 }
 }
stage('Build the application'){
steps{
echo 'cleaning..compiling..testing..packaging..'
sh 'mvn clean install package'
 }
 }
 
stage('Publish HTML Report'){
steps{
    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/healthcare_project3/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
 }
}
stage('Docker build image') {
              steps {
                  
                  sh'sudo docker system prune -af '
                  sh 'sudo docker build -t gururajdockerusername/healthcare:1.0 . '
              
                }
            }
stage('Docker login and push') {
              steps {
                  withCredentials([string(credentialsId: 'dockerpasswd', variable: 'dockerpasswd')]) {
                  sh 'sudo docker login -u gururajdockerusername -p ${dockerpasswd} '
                  sh 'sudo docker push gururajdockerusername/healthcare:1.0 '
                  }
                }
        }    
 stage (' setting up Kubernetes with terraform '){
            steps{

                dir('terraform_files'){
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                sh 'sleep 20'
                }
               
            }
        }
stage('deploy to application to kubernetes'){
steps{
sh 'sudo chmod 600 ./terraform_files/ubuntu-keypair.pem'    
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/ubuntu-keypair.pem medicure-deployment.yml ubuntu@172.31.19.53:/home/ubuntu/'
sh 'sudo scp -o StrictHostKeyChecking=no -i ./terraform_files/ubuntu-keypair.pem medicure-service.yml ubuntu@172.31.19.53:/home/ubuntu/'
script{
try{
sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/ubuntu-keypair.pem ubuntu@172.31.19.53 kubectl apply -f .'
}catch(error)
{
sh 'ssh -o StrictHostKeyChecking=no -i ./terraform_files/ubuntu-keypair.pem ubuntu@172.31.19.53 kubectl apply -f .'
}
}
}
}
}
}
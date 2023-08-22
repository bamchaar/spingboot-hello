pipeline {
    agent any 
    tools {
        maven "mvn"
    
    }
    stages {
        stage('Compile and Clean') { 
            steps {
                // Run Maven on a Unix agent.
              
                sh "mvn clean compile"

            }
        }
  stage('SCM') {
    checkout scm
  }
  stage('SonarQube Analysis') {
    def mvn = tool name: 'mvn', type: 'Maven';
    withSonarQubeEnv(sonar) {
      sh "mvn clean verify sonar:sonar -Dsonar.projectKey=java-sonarqube-helloworld-src"
    }
  }
        stage('deploy') { 
            
            steps {
                sh "mvn package"
            }
        }
        stage('Build Docker image'){
          
            steps {
                echo "Hello Java Express"
                sh 'ls'
                sh '''
                docker build -t  tcdmv/hello:1.0.0-${BUILD_NUMBER} .
                
                '''
            }
        }
        stage('Docker Login'){
            
            steps {
                 withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo '$DOCKER_PASSWORD' | docker login -u '$DOCKER_USERNAME' --password-stdin"
                }
            }                
        }
        stage('Docker Push'){
            steps {
                sh 'docker push tcdmv/hello:1.0.0-${BUILD_NUMBER}'
            }
        }
        stage('Docker deploy'){
            steps {
                     withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo '$DOCKER_PASSWORD' | docker login -u '$DOCKER_USERNAME' --password-stdin"
                }
                sh " docker pull tcdmv/hello:1.0.0-${BUILD_NUMBER}"
                sh 'docker run -itd -p  8081:8080 tcdmv/hello:1.0.0-${BUILD_NUMBER}'
            }
        }
        stage('Archving') { 
            steps {
                 archiveArtifacts '**/target/*.jar'
            }
        }
    }
}


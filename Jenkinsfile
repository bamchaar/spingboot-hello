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
                sh""
                mvn clean verify sonar:sonar \
  -Dsonar.projectKey=sonar_Helloworld-mvn \
  -Dsonar.projectName='sonar_Helloworld-mvn' \
  -Dsonar.host.url=http://54.209.208.168:9000 \
  -Dsonar.token=sqp_bf9e5692fcb190dda2ddedfe1880002e80966942
                ""

                

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
                sh 'docker build -t  tcdmv/hello:1.0.0-${BUILD_NUMBER} .'
            }
        }
        stage('Docker Login'){
            
            steps {
                 withCredentials([string(credentialsId: 'DockerId', variable: 'Dockerpwd')]) {
                    sh "docker login -u tcdmv -p ${Dockerpwd}"
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
               
                sh 'docker run -itd -p  8081:8080 tcdmv/hello:${BUILD_NUMBER}'
            }
        }
        stage('Archving') { 
            steps {
                 archiveArtifacts '**/target/*.jar'
            }
        }
    }
}


pipeline {
  agent { label 'senthil-laptop' }

  stages {
      stage('Build Artifact - Laptop') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
      stage('Unit Tests - JUnit and Jacoco ') {
            steps {
              sh "mvn test"              
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
        }
      stage('Mutation Tests - PIT ') {
            steps {
              sh "mvn clean org.pitest:pitest-maven:mutationCoverage"              
            }
            post {
              always {
                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
              }
            }
        }

      stage('Docker Build and Docker Hub Push') {
        steps {
          withDockerRegistry(credentialsId: 'dockerhub-cloudsenthil', url: '') {
            sh 'printenv'
            sh 'docker build -t cloudsenthil/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push cloudsenthil/numeric-app:""$GIT_COMMIT""'
            sh 'docker rmi cloudsenthil/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
//      stage('Kubernetes Deploy - Dev') {
//        agent { label 'kube-master' }
//        steps {
//          checkout scm
//          sh "sed -i 's#replace#cloudsenthil/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
//          sh "kubectl apply -f k8s_deployment_service.yaml"
//        }
//      }
    }
}

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
      stage('SonarQube - SAST') {
            steps {
              sh "mvn clean verify sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://localhost:9001 -Dsonar.login=sqp_e92b12908ac67e4ca5855bcfff6f31665bf590aa"
            }
        }
//      stage('Mutation Tests - PIT ') {
//        steps {
//              sh "mvn org.pitest:pitest-maven:mutationCoverage"              
//            }
//            post {
//              always {
//                pitmutation mutationStatsFile: '**/target/pit-reports/**/index.html'
//              }
//            }
//        }

//      stage('Docker Build and Docker Hub Push') {
//        steps {
//          withDockerRegistry(credentialsId: 'dockerhub-cloudsenthil', url: '') {
//            sh 'printenv'
//            sh 'docker build -t cloudsenthil/numeric-app:""$GIT_COMMIT"" .'
//            sh 'docker push cloudsenthil/numeric-app:""$GIT_COMMIT""'
//            sh 'docker rmi cloudsenthil/numeric-app:""$GIT_COMMIT""'
//          }
//        }
//      }
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

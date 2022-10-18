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
      stage('Docker Build and Push') {
        steps {
          withDockerRegistry([credentialsId: "dockerhub-cloudsenthil", url: ""]) {
            sh 'printenv'
            sh 'docker build cloudsenthil/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push cloudsenthil/numeric-app:""$GIT_COMMIT""'
          }
        }
      }
    }
}

pipeline {
  agent { label 'senthil-laptop' }

  stages {
      stage('Build Artifact - Laptop') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
      stage('Unit Tests - JUnit and Jacaco ') {
            steps {
              sh "mvn test"              
            }
            post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacaco execPattern: 'target/jacaco.exec'
              }
            }
        }
    }
}

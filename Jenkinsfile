pipeline {
  agent { label 'senthil-laptop' }

  stages {
      stage('Build Artifact - Laptop') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
      stage('Unit Test') {
            steps {
              sh "mvn test"              
            }
        }
    }
}

pipeline {
  agent any

  environment {
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName = "cloudsenthil/numeric-app:${GIT_COMMIT}"
    applicationURL = "http://senthil.uksouth.cloudapp.azure.com/"
    applicationURI = "/increment/99"
  }

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
      stage('Unit Tests - JUnit and Jacoco ') {
            steps {
              sh "mvn test"              
            }
        }
      stage('Mutation Tests - PIT ') {
        steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage"              
            }
          }
      stage('SonarQube - SAST') {
            steps {
              withSonarQubeEnv('SonarQube') {
                  sh "mvn clean verify sonar:sonar -Dsonar.projectKey=Machinations -Dsonar.host.url=http://senthil.uksouth.cloudapp.azure.com:9000"
              }
              timeout(time: 2, unit: 'MINUTES') {
                script {
                  waitForQualityGate abortPipeline: true
                 }
              }
            }
        }

      stage('Vulenarability Scan Dependency ') {
        steps {
          parallel(
              "Dependency Scan": {
              sh "mvn dependency-check:check"
              },
              "Trivy Scan": {
                sh "bash trivy-docker-image-scan.sh"
              },
              "OPA Conftest": {
                sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
              }
              )
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
      stage('Vulenarability Scan - Kubernetes') {
        steps {
              sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'              
            }
          }
//      stage('Kubernetes Deploy - Dev') {
//        steps {
//            withKubeConfig(credentialsId: 'kubeconfig') {
//          checkout scm
//          sh "sed -i 's#replace#cloudsenthil/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
//          sh "kubectl apply -f k8s_deployment_service.yaml"
//          }
//          }
//      }
      stage(' Kubernetes Deploy - Dev ') {
        steps {
          parallel(
              "Deployment": {
                withKubeConfig(credentialsId: 'kubeconfig') {
                  sh "bash k8s-deployment.sh"
                }              
              },
              "RollOut Status": {
                withKubeConfig(credentialsId: 'kubeconfig') {
                sh "bash k8s-deployment-rollout-status.sh"
                }
              }
              )
            }
          }
    }
    post {
              always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
            //    pitmutation mutationStatsFile: '**/target/pit-reports/**/index.html'
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
              }
            }
}

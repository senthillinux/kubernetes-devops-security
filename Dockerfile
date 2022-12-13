FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline && adduser -S devsecops-pipeline -G pipeline
COPY ${JAR_FILE} /home/devsecops-pipeline/app.jar
USER devsecops-pipeline
ENTRYPOINT ["java","-jar","/home/devsecops-pipeline/app.jar"]
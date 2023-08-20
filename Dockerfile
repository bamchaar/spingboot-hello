FROM openjdk:11-jdk-slim
RUN mvn clean && mvn package

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

EXPOSE 3080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]

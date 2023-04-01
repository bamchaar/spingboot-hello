FROM openjdk:8

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

EXPOSE 3080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]

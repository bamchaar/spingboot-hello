FROM openjdk:11-jdk-slim
ARG MAVEN_VERSION=3.8.2
ARG MAVEN_HOME=/usr/share/maven

RUN curl -fsSL https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar -xzC /usr/share \
&& mv /usr/share/apache-maven-${MAVEN_VERSION} /usr/share/maven \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME $MAVEN_HOME
ENV PATH $MAVEN_HOME/bin:$PATH
RUN mvn clean && mvn package

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

EXPOSE 3080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]

FROM openjdk:11-jdk-slim
# Define the Maven version
ARG MAVEN_VERSION=3.8.2

# Install curl
RUN apt-get update && apt-get install -y curl

# Download Maven archive
RUN curl -fsSL -o maven.tar.gz https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz 

# Check if the file was downloaded correctly
RUN ls -l

# Extract and set up Maven
RUN tar -xzC /usr/share -f maven.tar.gz && \
    mv /usr/share/apache-maven-${MAVEN_VERSION} /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Clean up downloaded files if necessary
RUN rm maven.tar.gz

# Set Maven environment variables
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH
RUN mvn clean && mvn package

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

EXPOSE 3080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]

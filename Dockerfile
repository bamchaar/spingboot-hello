FROM openjdk:11-jdk-slim

# Update packages and install prerequisites
RUN apt-get update \
    && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker's GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
RUN apt-get update && apt-get install -y docker-ce

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
After creating this Dockerfile:

Build the Docker image:

bash
Copy code
docker build -t docker-in-docker .
Run a container using the image:

bash
Copy code
docker run -it --rm docker-in-docker

# Define the Maven version
ARG MAVEN_VERSION=3.9.4

# Install curl
RUN apt-get update && apt-get install -y curl
# Install docker
# Download Maven archive
RUN curl -fsSL -o maven.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz 

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

COPY ./pom.xml ./pom.xml
COPY ./src ./src

RUN mvn clean && mvn package

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

EXPOSE 3080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]

# Use an official Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and the source code into the container
COPY pom.xml .
COPY src ./src

# Package the application
RUN mvn clean package

# Use a smaller image for running the application
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged jar file from the build stage to the final image
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
EXPOSE 80

# Specify the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

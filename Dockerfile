# Use an official Maven image to build the application
# This stage will build the application
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and the source code into the container
COPY pom.xml .
COPY src ./src

# Build the application (this will compile and package the application into a JAR file)
RUN mvn clean package -DskipTests

# Use a smaller image for running the application
# This stage will run the application
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the 'build' stage into the 'app' directory in the container
COPY --from=build /app/target/myapp-1.0-SNAPSHOT.jar /app/myapp.jar

# Expose the port the application will run on
EXPOSE 8080

# Command to run the application (java -jar <JAR file>)
CMD ["java", "-jar", "myapp.jar"]

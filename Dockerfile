# --- Stage 1: Build the application using Maven ---
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /workspace/app
COPY pom.xml .
COPY src/ ./src/
RUN mvn package -DskipTests

# --- Stage 2: Create the final, slim container image ---
FROM eclipse-temurin:17-jre-jammy
COPY --from=build /workspace/app/target/*.jar app.jar
# The port is set by the Kubernetes manifest
ENTRYPOINT ["java", "-jar", "app.jar"]

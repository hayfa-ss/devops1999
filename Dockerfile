FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copier le JAR compilé
COPY target/timesheet-devops-1.0.jar app.jar

# Port d'écoute
EXPOSE 8082

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]

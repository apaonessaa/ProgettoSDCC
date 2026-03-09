# ---------- BUILD STAGE ----------
FROM maven:3.9.6-eclipse-temurin-21-jammy AS builder

WORKDIR /build
COPY ./app/pom.xml .
COPY ./app/src ./src
RUN mvn -B -q -e -DskipTests dependency:go-offline
RUN mvn -B -DskipTests package

# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:21-jdk-jammy

# Create a group and non-root user
RUN addgroup --gid 1234 spring \
 && adduser --uid 1234 --gid 1234 --home /home/spring --disabled-password spring

# Directory per immagini e config
RUN mkdir -p /home/spring/images \
 && mkdir -p /home/spring/config \
 && chown -R spring:spring /home/spring

ENV IMAGE_PATH=/home/spring/images/
ENV IMAGE_CONFIG_PATH=/home/spring/config/validator.json

WORKDIR /home/spring

# Copy JAR
COPY --from=builder /build/target/*jar /home/spring/app.jar

# Copy validator configuration
COPY ./validator.json /home/spring/config/validator.json

# Run the application
USER spring:spring
EXPOSE 8000
ENTRYPOINT ["java","-jar","/home/spring/app.jar"]

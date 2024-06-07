FROM maven:3.8.1-jdk-11 AS build

# Копируем pom.xml и собираем зависимости для ускорения процесса сборки
COPY pom.xml /usr/src/app/
WORKDIR /usr/src/app
RUN mvn dependency:go-offline

# Копируем исходный код и собираем приложение
COPY . /usr/src/app
RUN mvn package

# Создаем Docker образ с собранным приложением
FROM openjdk:11-jre-slim
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/target/MavenProjectSearadar_jar/MavenProjectSearadar.jar /usr/src/app/app.jar
CMD ["java", "-jar", "app.jar"]
# Multiplayer Picross

A minimal Java 21 / Spring Boot website. Spring Boot serves the HTML and CSS
directly, so no Node.js installation or separate frontend server is needed.

## Run locally

Install JDK 21, then run from the repository root:

```sh
./mvnw spring-boot:run
```

On Windows, use `mvnw.cmd` instead of `./mvnw`.
Open http://localhost:8080 in your browser. Stop the server with Ctrl+C.
Set the `PORT` environment variable to use a different port.
The Maven wrapper downloads Maven on first use and needs Internet access.

### This cloud workspace

This workspace has a local JDK and Maven proxy settings prepared outside the
repository. Run here with:

```sh
JAVA_HOME=/workspace/tools/java21 ./mvnw -s /workspace/tools/maven-settings.xml spring-boot:run
```

Use the same prefix and settings for `test` or `package`. These paths are specific
to this cloud workspace; on your own machine, use the standard commands above.

## Test and build

```sh
./mvnw test
./mvnw package
java -jar target/multiplayer-picross-0.0.1-SNAPSHOT.jar
```

## Project layout

- `src/main/java/com/multiplayerpicross/` — application entry point; add controllers and game services here.
- `src/main/resources/static/index.html` — homepage.
- `src/main/resources/static/css/styles.css` — page styles.
- `src/main/resources/application.properties` — application settings.
- `src/test/java/com/multiplayerpicross/` — Spring Boot tests.

## Next steps

Add a puzzle model and board UI, then room creation/joining and WebSocket updates
for two players. There is no database, authentication, or multiplayer logic yet.

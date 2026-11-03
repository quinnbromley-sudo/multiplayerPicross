# Multiplayer Picross

A Java 21 / Spring Boot REST backend and a React + TypeScript frontend built with
Vite. The starter includes a landing page that checks the backend connection.
Game boards, rooms, WebSocket handlers, authentication, and persistence are not
implemented yet.

## Requirements

- JDK 21, with `JAVA_HOME` pointing to the JDK installation folder.
- Node.js 24 LTS (recommended), or Node.js 22.12+ in the 22 release line; npm is included.
- Internet access for the first Maven run and npm dependency installation.

Maven is provided by the wrapper; you do not need to install it separately.

## Development (including Windows Git Bash)

Open two terminals in the repository root.

**Terminal 1 — backend:**

```bash
cd backend
./mvnw spring-boot:run
```

**Terminal 2 — frontend:**

```bash
cd frontend
npm ci
npm run dev
```

Open http://localhost:5173 in your browser. The page should say **Game server
connected**. Spring Boot listens on port 8080; its health endpoint is
`GET /api/health`, returning `{"status":"UP"}`. Stop each server with Ctrl+C.
In Windows PowerShell or Command Prompt, use `mvnw.cmd` instead of `./mvnw`.

Edit `frontend/src/App.tsx` to change the page. Vite updates the browser as you
save. Add backend controllers and services under
`backend/src/main/java/com/multiplayerpicross/` and restart Spring Boot after
backend changes.

Vite forwards `/api` HTTP requests and `/ws` WebSocket connections to port 8080.
The `/ws` route is prepared for future development; there is no WebSocket server
yet. Keep browser API URLs relative, like `/api/health`. No broad CORS policy is
needed with this proxy. If you change the backend's `PORT` environment variable,
update the proxy targets in `frontend/vite.config.ts` too.

## Test and build

From `backend/`:

```bash
./mvnw verify
java -jar target/multiplayer-picross-0.0.1-SNAPSHOT.jar
```

From `frontend/`:

```bash
npm ci
npm run lint
npm run build
```

The frontend build includes TypeScript checking and produces `frontend/dist/`.
The backend build produces an executable JAR in `backend/target/`. These are
separate artifacts: the JAR does not serve the React frontend. For production,
serve `dist/` with a static web server and proxy `/api` and `/ws` to Spring Boot.
Vite's development server is for local development. No production deployment is
configured yet.

GitHub Actions checks both projects on pushes and pull requests.

## Project layout

```text
backend/
  .mvn/                    Maven wrapper configuration
  src/main/java/           Spring Boot entry point and REST controllers
  src/main/resources/      Application properties
  src/test/java/           Backend integration test
  pom.xml
frontend/
  src/App.tsx              Landing page and backend connection check
  src/App.css              Component styles
  src/index.css            Global styles
  vite.config.ts           Development HTTP and WebSocket proxy
  package.json
```

## This cloud workspace

The prepared JDK and Maven proxy configuration are outside the checkout. In
`backend/`, use:

```bash
JAVA_HOME=/workspace/tools/java21 ./mvnw -s /workspace/tools/maven-settings.xml spring-boot:run
```

Use the same prefix and settings for `verify`. These paths apply only to this
cloud workspace; use the standard commands above on your Windows machine.

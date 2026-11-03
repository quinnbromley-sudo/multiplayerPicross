#!/usr/bin/env bash
set -euo pipefail

# Resolve paths relative to this file, even when launched from another folder.
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

case "${1:-}" in
  --backend)
    cd -- "$project_dir/backend"
    exec bash ./mvnw spring-boot:run
    ;;
  --frontend)
    cd -- "$project_dir/frontend"
    if [[ ! -d node_modules ]]; then
      npm ci
    fi
    exec npm run dev
    ;;
  '') ;;
  *) echo "Usage: bash start-dev.sh" >&2; exit 1 ;;
esac

case "$(uname -s)" in
  MINGW*|MSYS*) ;;
  *) echo "Run this launcher in Windows Git Bash." >&2; exit 1 ;;
esac

if ! command -v mintty >/dev/null 2>&1; then
  echo "Cannot find mintty. Open Git Bash from the Windows Start menu and retry." >&2
  exit 1
fi

if [[ -z "${JAVA_HOME:-}" ]]; then
  echo "Set JAVA_HOME to your JDK 21 installation folder first." >&2
  exit 1
fi

# JAVA_HOME may use Windows notation, such as C:\Program Files\Java\jdk-21.
java_dir="$(cygpath -u "$JAVA_HOME")"
if [[ ! -x "$java_dir/bin/java.exe" || ! -x "$java_dir/bin/javac.exe" ]]; then
  echo "JAVA_HOME must point to a JDK installation containing java.exe and javac.exe." >&2
  exit 1
fi

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  echo "Install Node.js 24 LTS, reopen Git Bash, and retry." >&2
  exit 1
fi

# Pass paths as arguments so spaces and shell characters remain intact.
# Keep failed startup output visible until the user dismisses the window.
run_service='bash "$1" "$2"; result=$?; printf "\nServer stopped (exit %s). Press Enter to close.\n" "$result"; read -r; exit "$result"'
mintty --title 'Picross backend' /usr/bin/bash -c "$run_service" _ "$project_dir/start-dev.sh" --backend &
mintty --title 'Picross frontend' /usr/bin/bash -c "$run_service" _ "$project_dir/start-dev.sh" --frontend &

echo "Opening backend and frontend terminals."
echo "Once Vite is ready, open http://localhost:5173 in your browser."
echo "Stop each server with Ctrl+C in its own window."

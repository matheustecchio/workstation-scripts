#!/usr/bin/env bash

# Generates a starter Dockerfile for common stacks.

set -euo pipefail

STACK="${1:-}"
PORT="${2:-}"
OUTPUT_FILE="Dockerfile"

prompt_if_empty() {
    local var_name="$1"
    local prompt_text="$2"
    local current_value="$3"

    if [ -z "$current_value" ]; then
        read -r -p "$prompt_text" current_value
    fi

    printf -v "$var_name" '%s' "$current_value"
}

prompt_if_empty STACK 'Stack [node/python/go/java]: ' "$STACK"
prompt_if_empty PORT 'Expose port [press enter to skip]: ' "$PORT"

if [ -e "$OUTPUT_FILE" ]; then
    printf '%s already exists in %s\n' "$OUTPUT_FILE" "$PWD" >&2
    exit 1
fi

case "$STACK" in
    node)
        cat <<EOF > "$OUTPUT_FILE"
FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
EOF
        if [ -n "$PORT" ]; then
            printf 'EXPOSE %s\n' "$PORT" >> "$OUTPUT_FILE"
        fi
        cat <<'EOF' >> "$OUTPUT_FILE"

CMD ["npm", "run", "dev"]
EOF
        ;;
    python)
        cat <<EOF > "$OUTPUT_FILE"
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EOF
        if [ -n "$PORT" ]; then
            printf 'EXPOSE %s\n' "$PORT" >> "$OUTPUT_FILE"
        fi
        cat <<'EOF' >> "$OUTPUT_FILE"

CMD ["python", "main.py"]
EOF
        ;;
    go)
        cat <<EOF > "$OUTPUT_FILE"
FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.* ./
RUN go mod download

COPY . .
RUN go build -o app .

FROM alpine:3.22

WORKDIR /app
COPY --from=builder /app/app ./app
EOF
        if [ -n "$PORT" ]; then
            printf 'EXPOSE %s\n' "$PORT" >> "$OUTPUT_FILE"
        fi
        cat <<'EOF' >> "$OUTPUT_FILE"

CMD ["./app"]
EOF
        ;;
    java)
        cat <<EOF > "$OUTPUT_FILE"
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

COPY . .
RUN if [ -x ./mvnw ]; then ./mvnw package -DskipTests; else mvn package -DskipTests; fi

FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EOF
        if [ -n "$PORT" ]; then
            printf 'EXPOSE %s\n' "$PORT" >> "$OUTPUT_FILE"
        fi
        cat <<'EOF' >> "$OUTPUT_FILE"

CMD ["java", "-jar", "app.jar"]
EOF
        ;;
    *)
        printf 'Unsupported stack: %s\n' "$STACK" >&2
        printf 'Supported stacks: node, python, go, java\n' >&2
        exit 1
        ;;
esac

printf 'Created %s for %s\n' "$OUTPUT_FILE" "$STACK"

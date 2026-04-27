# Full-Stack Application: Docker Setup & Usage Guide

This repository contains a professional Docker configuration for a full-stack application consisting of a React Frontend, a Node.js Backend, and a MongoDB Database.

## 🏗 Project Architecture

We utilize a Service-Oriented Architecture where each component is isolated in its own container. This is managed via:

- **backend.Dockerfile**: Multi-stage build for the API.
- **frontend.Dockerfile**: Multi-stage build using Nginx to serve static assets.
- **docker-compose.yml**: The orchestration layer that connects the services, databases, and networks.

## 📄 File Breakdown

### 1. Backend Dockerfile (backend.Dockerfile)

**Purpose**: Builds a secure, production-ready Node.js environment.

**Key Features:**

- **Multi-Stage Build**: Separates the installation of dependencies from the final execution to keep the image slim.
- **Non-Root Security**: Runs the application under the node user instead of root.
- **Alpine Base**: Uses node:18-alpine to reduce the attack surface and image size.

### 2. Frontend Dockerfile (frontend.Dockerfile)

**Purpose**: Compiles the React/Vue code and serves it via a high-performance web server.

**Key Features:**

- **Build Stage**: Uses Node.js to perform npm run build.
- **Production Stage**: Uses nginx:alpine. Once the build is finished, the Node.js environment is discarded, leaving only the static files and Nginx.

### 3. Docker Compose (docker-compose.yml)

**Purpose**: The "Glue" that allows you to start the entire stack with one command.

**Responsibilities:**

- **Networking**: Automatically creates a private network so the backend can reach the database using the hostname database.
- **Environment Variables**: Passes configuration like DB_URL to the services.
- **Persistence**: Uses a Named Volume (db-data) to ensure your database information isn't lost if the container stops.

## 🚀 How to Use

### Prerequisites

- Docker and Docker Compose installed on your machine.

### Starting the Application

To build the images and start all services in the background:

```bash
docker-compose up -d --build
```

### Accessing the Services

- **Frontend**: http://localhost (Port 80)
- **Backend API**: http://localhost:5000

### Stopping the Application

To stop the containers but keep the data in your database:

```bash
docker-compose down
```

To stop the containers and wipe all data:

```bash
docker-compose down -v
```

## 🛠 Best Practices Implemented

- **Layer Caching**: Dependencies are installed before copying source code to speed up rebuilds.
- **Security**: Containers run with minimal privileges.
- **Isolation**: The frontend never talks directly to the database; it must go through the API.
- **Immutability**: Production images contain a snapshot of the code, ensuring the app runs exactly the same in every environment.

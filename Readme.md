# Docker Master Guide: From Fundamentals to Orchestration

This guide serves as a comprehensive deep-dive into Docker. It covers the architectural "DNA" of your applications—the Dockerfile—and explains how to manage data, networking, and multi-container environments effectively.

## 1. The Core Architecture: Images vs. Containers

Docker is built on two primary concepts that represent the difference between a "blueprint" and a "building."

### Images: The Blueprints (Read-Only)

An Image is a lightweight, standalone, executable package that includes everything needed to run a piece of software: code, runtime, system tools, and libraries.

- **Immutable**: Once built, an image cannot be changed. To update code, you must rebuild the image.
- **Layer-Based**: Each instruction in a Dockerfile creates a "layer." Docker uses Caching to reuse layers that haven't changed, making subsequent builds significantly faster.
- **Storage**: Images are stored locally or in registries like DockerHub.

### Containers: The Running Instances (Read-Write)

A Container is a runtime instance of an image.

- **Isolation**: Containers run in their own isolated environment. They don't see the host's files or other containers unless explicitly configured.
- **Ephemeral**: By default, data written inside a container is lost when the container is deleted.
- **Writable Layer**: When a container starts, Docker adds a thin "Read-Write" layer on top of the read-only image layers.

## 2. Deep Dive: The Dockerfile

The Dockerfile is a script containing instructions to assemble an image.

### Essential Instructions & Examples

| Instruction | What it does | Example / Best Practice |
| :--- | :--- | :--- |
| `FROM` | Sets the Base Image. | `FROM node:18-alpine` (Use 'alpine' for smaller images) |
| `WORKDIR` | Sets the internal execution directory. | `WORKDIR /app` (Avoids cluttering the root `/` folder) |
| `COPY` | Copies files from host to image. | `COPY package.json .` (Copy deps first to leverage cache) |
| `RUN` | Executes commands during build. | `RUN npm install` |
| `ENV` | Sets persistent environment vars. | `ENV DB_URL=mongodb://db:27017` |
| `ARG` | Build-time variables (not in container). | `ARG VERSION=1.0` |
| `EXPOSE` | Documentation of the port used. | `EXPOSE 8080` |
| `CMD` | The default command at runtime. | `CMD ["npm", "start"]` |

### Multi-Stage Builds (For Production)

Multi-stage builds allow you to use a large image for building (with compilers/tools) and a tiny image for running (production).

```dockerfile
# Stage 1: Build
FROM node:18 AS build-stage
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Stage 2: Production
FROM nginx:alpine
COPY --from=build-stage /app/dist /usr/share/nginx/html
```

## 3. Data Persistence: Volumes & Bind Mounts

Since containers are ephemeral, we use external storage to save data.

### Comparison Table

| Feature | Named Volumes | Bind Mounts |
| :--- | :--- | :--- |
| **Managed By** | Docker (`/var/lib/docker/volumes`) | You (Any folder on your PC) |
| **Best Use Case** | Databases, Production Persistent Data | Development (Hot-reloading code) |
| **Portability** | High (Works on any OS) | Low (Tied to your specific file path) |
| **Performance** | Native speed | Slower on macOS/Windows |

### Useful Storage Commands

- **Run with Bind Mount**: `docker run -v /Users/me/project:/app my-image`
- **Run with Named Volume**: `docker run -v db-data:/data/db mongo`
- **Cleanup**: `docker volume prune` (Deletes all unused volumes)

## 4. Networking: How Containers Talk

Containers live in isolated networks. Docker handles the "translation" of addresses.

- **To the World (WWW)**: Works out of the box. Containers can ping `google.com` immediately.
- **To the Host Machine**: Use the special DNS `host.docker.internal`.
  - Example: `fetch('http://host.docker.internal:3000')`

- **To Other Containers**:
  - *The Old Way*: Link via IP (Bad, IPs change).
  - *The Proper Way*: User-defined Networks. Containers on the same network reach each other via their Container Name.

```bash
docker network create my-app-net
docker run --network my-app-net --name web-api my-image
# Other containers can now use URL: http://web-api
```

## 5. Orchestration: Docker Compose

Docker Compose is a tool for defining and running multi-container applications using a `docker-compose.yaml` file.

### Key Features

- **Declarative**: You define the "end state," and Docker makes it happen.
- **Automatic Networking**: It creates a shared network for all services automatically.
- **Environment Management**: Easily load variables from a `.env` file.

### Example `docker-compose.yaml`

```yaml
version: "3.8"
services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DB_NAME=users
    depends_on:
      - database
  database:
    image: mongo
    volumes:
      - db-data:/data/db

volumes:
  db-data:
```

## 6. Essential CLI Cheat Sheet

### Image Management

- `docker build -t app:v1 .` : Build an image with a name and tag.
- `docker images` : List all local images.
- `docker rmi <id>` : Remove a specific image.

### Container Management

- `docker run -d --name my-app -p 80:80 app:v1` : Run in background (detached), name it, map host port 80 to container port 80.
- `docker ps -a` : See all containers (including stopped ones).
- `docker exec -it my-app sh` : Enter a running container's terminal.
- `docker logs -f my-app` : Follow the live output/logs.

### System Cleanup

- `docker system prune` : The "Nuke" command. Removes all stopped containers, unused networks, and dangling images.

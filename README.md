*This project has been created as part of the 42 curriculum by jpedro-f.*

# Inception

## Description

Inception is a system administration project that uses Docker to set up a small infrastructure composed of different services. The goal is to virtualize a complete web stack using Docker containers, each running a specific service:

- **NGINX** — web server, only entrypoint via port 443 (HTTPS)
- **WordPress + PHP-FPM** — content management system
- **MariaDB** — database server

All services run in dedicated containers, communicate through a Docker network, and persist data through Docker named volumes.

## Instructions

### Requirements
- Docker
- Docker Compose
- Make
- Git

### Setup

1. Clone the repository:
```bash
git clone https://github.com/jvieira96/42_Inception.git
cd 42_Inception
```

2. Build and start the project:
```bash
make
```
The Makefile will automatically:
- Add jpedro-f.42.fr to /etc/hosts
- Create data directories
- Build and start all containers

3. Access the website:
```
https://jpedro-f.42.fr
```

4. Access the admin panel:
```
https://jpedro-f.42.fr/wp-admin
```

### Available commands

| Command | Description |
|---|---|
| `make` | Build and start all containers |
| `make down` | Stop all containers |
| `make clean` | Stop containers and remove volumes |
| `make fclean` | Remove everything including images and data |
| `make re` | Full clean and rebuild |
| `make ps` | Show container status |

## Project Description

### What is Docker?

Docker is a containerization platform that allows you to package applications and their dependencies into isolated containers. Each container runs as an independent process sharing the host OS kernel, making it much lighter and faster than traditional virtual machines.

### Virtual Machines vs Docker

| | Virtual Machines | Docker |
|---|---|---|
| Size | Several GB | Few MB |
| Startup time | Minutes | Seconds |
| Isolation | Full OS isolation | Process isolation |
| Performance | Lower (hypervisor overhead) | Near native |
| Portability | Less portable | Highly portable |
| OS | Each VM has its own OS | Shares host OS kernel |

Virtual Machines virtualize an entire operating system including the kernel. Docker containers share the host kernel and only isolate the application and its dependencies. This makes Docker much lighter, faster and more efficient than VMs.

### Secrets vs Environment Variables

| | Docker Secrets | Environment Variables |
|---|---|---|
| Storage | Files in /run/secrets/ | .env file |
| Security | More secure, memory only | Less secure |
| Visibility | Not visible in docker inspect | Visible in docker inspect |
| Use case | Passwords, API keys | Configuration, URLs |

Environment variables stored in .env files are simpler but slightly less secure as they can be exposed through docker inspect. Docker secrets are mounted as temporary files in memory and are never written to disk. In this project we use a .env file ignored by git for security.

### Docker Network vs Host Network

| | Docker Network | Host Network |
|---|---|---|
| Isolation | Private isolated network | Shares host network |
| Security | More secure | Less secure |
| DNS | Automatic container DNS | No automatic DNS |
| Communication | Via container names | Via localhost |
| Subject | Required ✅ | Forbidden ❌ |

Docker network creates a private isolated network where containers communicate using their service names as hostnames. This project uses a bridge network called inception where all containers communicate internally. Host network removes isolation completely and is forbidden by the subject.

### Docker Volumes vs Bind Mounts

| | Docker Volumes | Bind Mounts |
|---|---|---|
| Management | Managed by Docker | Manual host path |
| Portability | More portable | Less portable |
| Performance | Better | Slightly worse |
| Backup | Easier | Manual |
| Subject | Required ✅ | Forbidden for data ❌ |

Docker volumes are managed by Docker and provide better isolation and portability. Bind mounts directly map a host directory to a container. This project uses named volumes with data stored at /home/jpedro-f/data/ as required by the subject.

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)
- [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)
- [OpenSSL Documentation](https://www.openssl.org/docs/)

### Articles and Tutorials
- [Docker vs Virtual Machines](https://www.docker.com/resources/what-container/)
- [PID 1 and Docker best practices](https://cloud.google.com/architecture/best-practices-for-building-containers)
- [TLS/SSL explained](https://www.cloudflare.com/learning/ssl/what-is-ssl/)
- [NGINX FastCGI and PHP-FPM](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)
- [MariaDB Security](https://mariadb.com/kb/en/securing-mariadb/)

### How AI was used

AI was used as a learning and assistance tool throughout this project:

- **Understanding concepts** — Docker architecture, PID 1, layers, volumes, networks, TLS/SSL
- **Configuration syntax** — nginx.conf directives, php-fpm www.conf, MariaDB configuration
- **Debugging** — analyzing container logs and fixing startup errors
- **Documentation** — structuring and writing project documentation
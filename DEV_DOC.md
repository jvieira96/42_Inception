# Developer Documentation

## 1. Prerequisites

Before setting up the project, ensure the following are installed on your machine:

- **Docker** — container runtime
- **Docker Compose** — multi-container orchestration
- **Make** — build automation
- **Git** — version control
- **OpenSSL** — SSL certificate generation (included in NGINX Dockerfile)

To install on Debian/Ubuntu:
```bash
sudo apt-get update
sudo apt-get install -y docker.io docker-compose make git
sudo usermod -aG docker $USER
```
Log out and back in after adding your user to the docker group.

## 2. Project Structure

```
inception/
├── Makefile                          → build and management commands
├── README.md                         → project overview
├── USER_DOC.md                       → user documentation
├── DEV_DOC.md                        → developer documentation
└── srcs/
    ├── .env                          → environment variables (not in git)
    ├── docker-compose.yml            → service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile            → MariaDB image recipe
        │   ├── conf/50-server.cnf    → MariaDB configuration
        │   └── tools/script.sh       → database setup script
        ├── wordpress/
        │   ├── Dockerfile            → WordPress image recipe
        │   ├── conf/www.conf         → PHP-FPM pool configuration
        │   └── tools/script.sh       → WordPress setup script
        └── nginx/
            ├── Dockerfile            → NGINX image recipe
            └── conf/nginx.conf       → NGINX configuration
```

## 3. Environment Setup from Scratch

### Step 1 — Clone the repository
```bash
git clone https://github.com/jvieira96/42_Inception.git
cd 42_Inception
```

### Step 2 — Create the .env file
The `.env` file is not included in the repository for security reasons.
Create it manually at `srcs/.env`:
```bash
nano srcs/.env
```

Fill in the following variables:
```bash
# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=yourdbuser
MYSQL_PASSWORD=yourdbpassword
MYSQL_ROOT_PASSWORD=yourrootpassword

# WordPress
WORDPRESS_DB_HOST=mariadb
WORDPRESS_URL=https://jpedro-f.42.fr
WORDPRESS_TITLE=Inception
WORDPRESS_ADMIN_USER=youradminuser
WORDPRESS_ADMIN_PASSWORD=youradminpassword
WORDPRESS_ADMIN_EMAIL=youremail@example.com
WORDPRESS_USER=yourseconduser
WORDPRESS_USER_EMAIL=seconduser@example.com
WORDPRESS_USER_PASSWORD=seconduserpassword
```

Important rules:
- `WORDPRESS_ADMIN_USER` must not contain `admin` or `administrator`
- Never commit this file to git
- Make sure `.env` is in your `.gitignore`

### Step 3 — Build and start
```bash
make
```

The Makefile will automatically:
- Add `jpedro-f.42.fr` to `/etc/hosts`
- Create data directories at `/home/jpedro-f/data/`
- Build all Docker images from their Dockerfiles
- Start all containers in the correct order

## 4. Building and Launching with Makefile and Docker Compose

### Makefile targets

| Command | Description |
|---|---|
| `make` | Setup hosts, create dirs, build and start all containers |
| `make down` | Stop and remove containers, keep volumes and images |
| `make clean` | Stop containers and remove volumes |
| `make fclean` | Remove everything — containers, volumes, images and data |
| `make re` | Full clean then rebuild everything from scratch |
| `make ps` | Show status of all containers |

### Docker Compose commands

These can also be run directly if needed:
```bash
# Build all images
docker compose -f srcs/docker-compose.yml build

# Start all containers
docker compose -f srcs/docker-compose.yml up -d

# Stop all containers
docker compose -f srcs/docker-compose.yml down

# View logs
docker compose -f srcs/docker-compose.yml logs -f

# View logs for specific service
docker compose -f srcs/docker-compose.yml logs -f mariadb
```

## 5. Managing Containers and Volumes

### Container management
```bash
# List running containers
docker ps

# Enter a running container
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash

# View container logs
docker logs mariadb
docker logs wordpress
docker logs nginx

# Restart a specific container
docker restart mariadb
docker restart wordpress
docker restart nginx

# Inspect a container
docker inspect mariadb
```

### Volume management
```bash
# List all volumes
docker volume ls

# Inspect a volume
docker volume inspect db-volume
docker volume inspect wordpress-volume

# Remove a specific volume (WARNING: data loss)
docker volume rm db-volume
docker volume rm wordpress-volume
```

### Network management
```bash
# List all networks
docker network ls

# Inspect the inception network
docker network inspect srcs_inception
```

### Database management
```bash
# Connect to MariaDB as WordPress user
docker exec -it mariadb mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE

# Connect to MariaDB as root
docker exec -it mariadb mysql -u root -p$MYSQL_ROOT_PASSWORD

# Useful SQL commands
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
SELECT * FROM wp_users;
```

## 6. Data Storage and Persistence

### How persistence works

Docker named volumes are used to persist data outside the containers.
When a container is deleted and recreated, it remounts the same volume
and finds the existing data intact.

### Volume locations on host machine

| Volume | Host path | Container path |
|---|---|---|
| `db-volume` | `/home/jpedro-f/data/mariadb` | `/var/lib/mysql` |
| `wordpress-volume` | `/home/jpedro-f/data/wordpress` | `/var/www/html/wordpress` |

### Verify data is persisting
```bash
# Check database files exist on host
ls /home/jpedro-f/data/mariadb

# Check WordPress files exist on host
ls /home/jpedro-f/data/wordpress
```

### Testing persistence
```bash
# Stop and remove all containers
make down

# Start again
make

# Data should still be there
ls /home/jpedro-f/data/mariadb
ls /home/jpedro-f/data/wordpress
```

### What gets persisted

- **MariaDB volume** — all database tables, WordPress posts, users, settings
- **WordPress volume** — WordPress core files, themes, plugins, uploaded media

### What does NOT persist (rebuilt on each build)

- SSL certificate — regenerated at build time in NGINX Dockerfile
- NGINX configuration — copied from conf/ at build time
- PHP-FPM configuration — copied from conf/ at build time
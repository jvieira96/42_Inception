# User Documentation

## 1. System Overview

This project is a containerized infrastructure managed via Docker Compose. It provides the following interconnected services:

- **NGINX**: Acts as the only entry point to the stack via port 443, using TLSv1.2/TLSv1.3 protocols.
- **WordPress**: A PHP-based website running with PHP-FPM 8.2.
- **MariaDB**: The database management system storing all WordPress site data.

## 2. Start and Stop

All tasks are handled through the Makefile located at the root of the repository.

- **Build and Start**: `make` to configure hosts, initialize volumes, build the images and start the containers.
- **Stop Services**: `make down` to stop and remove the containers without deleting the data.
- **Full Cleanup**: `make fclean` to remove containers, volumes, images and data.
- **Rebuild**: `make re` to perform a full clean and rebuild everything from scratch.
- **Status**: `make ps` to check the current status of all containers.

## 3. Access and Administration

Once the services are running, the website is accessible via the configured domain name:

- **Main Website**: `https://jpedro-f.42.fr`
- **Admin Dashboard**: `https://jpedro-f.42.fr/wp-admin`

Note: Access is strictly via HTTPS (port 443). HTTP requests (port 80) are not supported per security requirements.

Note: Your browser will show a warning about the self-signed SSL certificate. This is expected — click **Advanced** then **Proceed** to continue.

## 4. Credentials and Secrets

For security reasons, no credentials are stored in the Dockerfiles or the Git history.

All passwords, usernames and database names are defined in `srcs/.env` on the host machine. This file is never committed to git.

The following variables are available in `srcs/.env`:

- **Database**: `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`
- **WordPress Admin**: `WORDPRESS_ADMIN_USER`, `WORDPRESS_ADMIN_PASSWORD`, `WORDPRESS_ADMIN_EMAIL`
- **WordPress User**: `WORDPRESS_USER`, `WORDPRESS_USER_PASSWORD`, `WORDPRESS_USER_EMAIL`

You can modify these values before the initial build. After the first build, changes require a full rebuild with `make re`.

## 5. Service Verification

To confirm that the infrastructure is operational:

- **Container Status**: run `docker ps`. You should see three containers with status **Up**.
```bash
docker ps
```

- **Network Integrity**: run `docker network ls` to verify the inception network is active.
```bash
docker network ls
```

- **Volume Persistence**: verify that `srcs_db-volume` and `srcs_wordpress-volume` are active.
```bash
docker volume ls
```

- **Data Location**: verify that data is being persisted on the host machine.
```bash
ls /home/jpedro-f/data/mariadb
ls /home/jpedro-f/data/wordpress
```

- **SSL Check**: run the following to confirm NGINX TLS configuration is working.
```bash
curl -Ik https://jpedro-f.42.fr
```
A successful response will show `HTTP/2 200` and `TLSv1.3` or `TLSv1.2`.
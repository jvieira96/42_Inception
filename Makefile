################################################################################
#                                   CONFIG                                     #
################################################################################

NAME		= Inception
SRCS_DIR	= ./srcs
DATA_DIR	= /home/jpedro-f/data
MARIADB_DIR	= $(DATA_DIR)/mariadb
WP_DIR		= $(DATA_DIR)/wordpress
HOST_LINE	= "127.0.0.1 jpedro-f.42.fr"
DOCKER_COMPOSE	= docker compose -f $(SRCS_DIR)/docker-compose.yml

################################################################################
#                                  COLORS                                      #
################################################################################

RED			= \033[0;31m
GREEN		= \033[0;32m
YELLOW		= \033[0;33m
RESET		= \033[0m

################################################################################
#                                   RULES                                      #
################################################################################

all: setup_host data
	@if [ "$$(docker ps -q -f name=mariadb)" ]; then \
		echo "$(GREEN)Inception is already running!$(RESET)"; \
	else \
		$(DOCKER_COMPOSE) up --build -d; \
		echo "$(GREEN)Inception is up and running!$(RESET)"; \
	fi

setup_host:
	@if grep -q $(HOST_LINE) /etc/hosts; then \
		echo "$(GREEN)Host line already exists.$(RESET)"; \
	else \
		echo "$(YELLOW)Adding host line to /etc/hosts...$(RESET)"; \
		echo $(HOST_LINE) | sudo tee -a /etc/hosts; \
		echo "$(GREEN)Host line added.$(RESET)"; \
	fi

data:
	@if [ ! -d $(MARIADB_DIR) ] || [ ! -d $(WP_DIR) ]; then \
		mkdir -p $(MARIADB_DIR) && mkdir -p $(WP_DIR); \
		echo "$(GREEN)Data directories created.$(RESET)"; \
	fi

down:
	$(DOCKER_COMPOSE) down --remove-orphans
	echo "$(YELLOW)Containers stopped.$(RESET)"

clean:
	$(DOCKER_COMPOSE) down -v --remove-orphans
	echo "$(RED)Containers and volumes removed.$(RESET)"

fclean: clean
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	sudo rm -rf $(MARIADB_DIR)/*
	sudo rm -rf $(WP_DIR)/*
	docker system prune -af
	echo "$(RED)Full clean done.$(RESET)"

re: fclean all

ps:
	$(DOCKER_COMPOSE) ps

.PHONY: all setup_host data down clean fclean re ps
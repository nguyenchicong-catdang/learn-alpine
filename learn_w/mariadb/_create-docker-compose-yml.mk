#learn_w/mariadb/_create-docker-compose-yml.mk

define MARIADB_DOCKER_COMPOSE_YML
services:
 $(MARIADB_NAME):
  image: $(MARIADB_NAME)
  container_name: $(MARIADB_NAME)
  network_mode: "host"
  restart: always
  volumes:
   - $(MARIADB_NAME)-data:/var/lib/mysql

  healthcheck:
    test: ["CMD", "mariadb-admin", "ping", "-h", "localhost", "--silent"]
    interval: 10s      # Cứ mỗi 10 giây kiểm tra 1 lần
    timeout: 5s       # Chờ phản hồi tối đa 5 giây
    retries: 5        # Thử lại 5 lần, nếu lỗi cả 5 thì đánh dấu là "unhealthy"
    start_period: 30s # Cho phép database có 30 giây để khởi động trước khi bắt đầu check

volumes:
 $(MARIADB_NAME)-data:
endef

export MARIADB_DOCKER_COMPOSE_YML

_mariadb-create-docker-compose-yml:
	@echo "_mariadb-create-docker-compose-yml"
	@echo "$$MARIADB_DOCKER_COMPOSE_YML" > $(MARIADB_PROJECT_PATH)/docker-compose.yml

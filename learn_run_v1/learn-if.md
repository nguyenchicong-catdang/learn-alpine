# Cách 1: Dùng hàm if của Makefile (Tường minh nhất)
# Giả sử bạn có biến APP_ENV truyền vào từ bên ngoài hoặc mặc định
APP_ENV ?= development

# Logic gán giá trị dựa trên môi trường
ifeq ($(APP_ENV),development)
    BUILD_ARGS := --build-arg DEV_MODE=true --target dev_stage
else
    BUILD_ARGS := --no-cache --pull
endif

adminer-docker-build:
	@echo "Đang build cho môi trường: $(APP_ENV)"
	docker build $(BUILD_ARGS) -t $(IMAGE_APP) \
		-f $(ADMINER_PATH_APP)/Dockerfile $(ADMINER_PATH_APP)

# Cách 2: Dùng Shell Conditional (Viết trực tiếp trong Target)

adminer-docker-build:
	@if [ "$(APP_ENV)" = "development" ]; then \
		echo "Build kiểu DEVELOPMENT..."; \
		docker build -t $(IMAGE_APP)-dev -f $(ADMINER_PATH_APP)/Dockerfile $(ADMINER_PATH_APP); \
	else \
		echo "Build kiểu PRODUCTION..."; \
		docker build -t $(IMAGE_APP) -f $(ADMINER_PATH_APP)/Dockerfile $(ADMINER_PATH_APP); \
	fi


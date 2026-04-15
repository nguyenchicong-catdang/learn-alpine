make

make help

	docker build --network host -t $(IMAGE_NAME) -f $(PATH_NGINX)/Dockerfile $(PATH_NGINX)


docker run -d --name test-nginx -p 8080:80 $(IMAGE_NAME)
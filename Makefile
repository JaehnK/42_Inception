up:
	@echo "Initializing Docker Swarm..."
	@docker swarm init --advertise-addr $$(ip route get 8.8.8.8 | awk '{print $$7; exit}') 2>/dev/null || docker swarm init
	@echo "Building images..."
	@cd ./srcs && docker compose build
	@echo "Deploying stack..."
	@cd ./srcs && docker stack deploy -c docker-compose.yml inception
	@echo "Ensuring proper startup order..."
	@docker service scale inception_nginx=0 inception_wordpress=0 2>/dev/null || true
	@sleep 5
	@docker service scale inception_wordpress=1 
	@sleep 15
	@docker service scale inception_nginx=1
	
down:
	@docker stack rm inception || true
	@docker swarm leave --force 2>/dev/null || true
clean:
	@docker stack rm inception 2>/dev/null || true
	@docker swarm leave --force 2>/dev/null || true
	@docker system prune -af
	@docker volume prune -f

.PHONY: up down clean
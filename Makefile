up:
	docker swarm init 2>/dev/null || true
	cd ./srcs && docker compose build
	cd ./srcs && docker stack deploy -c docker-compose.yml inception

down:
	docker stack rm inception
	docker swarm leave --force 2>/dev/null || true

clean:
	docker stack rm inception 2>/dev/null || true
	docker swarm leave --force 2>/dev/null || true
	docker system prune -af
	docker volume prune -f

.PHONY: up down clean
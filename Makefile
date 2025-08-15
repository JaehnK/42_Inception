up:
	docker swarm init --advertise-addr 10.0.2.15 2>/dev/null || true
	cd ./srcs && docker compose build
	cd ./srcs && docker stack deploy -c docker-compose.yml inception

down:
	docker stack rm inception

clean:
	docker stack rm inception
	docker system prune -af
	docker volume prune -f

.PHONY: up down clean

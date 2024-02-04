up:
	docker-compose up -d

down:
	docker-compose down

migrate:
	docker-compose exec app mix ecto.migrate
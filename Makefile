up:
	docker-compose up -d

migrate:
	docker-compose exec app mix ecto.migrate
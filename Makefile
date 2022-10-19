POSTGRES_DB_SCHEMA := v1



postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=admin -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank 

createSchema:
	docker exec -it postgres12 psql -U root \connect simple123;CREATE SCHEMA v3;exit

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose down

sqlc:
	docker run --rm -v D:\bank\simplebank:/src -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...

.PHONY:postgres createdb dropdb migrateup migratedown sqlc test createSchema
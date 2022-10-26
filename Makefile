POSTGRES_DB_SCHEMA := public



postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=admin -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank 

# 選擇DB: \connect simple123;  創建SCHEMA: CREATE SCHEMA v3
postgresTerminal:
	docker exec -it postgres12 psql -U root 

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose up
migrateup1:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose down
migratedown1:
	migrate -path db/migration -database "postgresql://root:admin@localhost:5432/simple_bank?sslmode=disable&search_path=${POSTGRES_DB_SCHEMA}" -verbose down 1

sqlc:
	docker run --rm -v D:\bank\simplebank:/src -w /src kjconroy/sqlc generate
test:
	go test -v -cover ./...
server:
	go run main.go
mock:
	mockgen -package mock -destination db/mock/store.go bank/db/sqlc Store
# 紀錄指令
# 創建升級 migration migrate create -ext sql -dir db/migration -seq add_users

.PHONY:postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 sqlc test postgresTerminal server mock
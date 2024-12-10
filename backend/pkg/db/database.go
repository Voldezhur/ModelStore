package db

import (
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"

)

func ConnectDB() (*sqlx.DB, error) {

	dsn := "port=5432 user=postgres password=291199 dbname=shop sslmode=disable"

	db, err := sqlx.Connect("postgres", dsn)
	if err != nil {
		return nil, err
	}
	return db, nil

}








package models

import "time"

type User struct {
	UserID    int       `db:"user_id" json:"user_id"`
	UserName  string    `db:"username" json:"username"`
	Email     string    `db:"email" json:"email"`
	Password  float64   `db:"password_hash" json:"password_hash"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
}

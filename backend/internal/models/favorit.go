package models

import "time"

// Cart представляет структуру корзины
type Favorite struct {
	FavoriteID int       `db:"favorite_id" json:"favorite_id"`
	UserID     int       `db:"user_id" json:"user_id"`
	ProductID  int       `db:"product_id" json:"product_id"`
	AddedAt    time.Time `db:"added_at" json:"added_at"`
}

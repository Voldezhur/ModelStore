package models

import "time"

// Cart представляет структуру корзины
type Favourite struct {
	FavouriteID int       `db:"favourite_id" json:"favourite_id"`
	UserID      int       `db:"user_id" json:"user_id"`
	ProductID   int       `db:"product_id" json:"product_id"`
	AddedAt     time.Time `db:"added_at" json:"added_at"`
}

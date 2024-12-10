package models

import "time"

// Cart представляет структуру корзины
type Cart struct {
	CartID    int       `db:"cart_id" json:"cart_id"`
	UserID    int       `db:"user_id" json:"user_id"`
	ProductID int       `db:"product_id" json:"product_id"`
	Quantity  int       `db:"quantity" json:"quantity"`
	AddedAt   time.Time `db:"added_at" json:"added_at"`
}

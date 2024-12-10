package models

type Product struct {
	ProductID   int     `db:"product_id" json:"product_id"`
	Name        string  `db:"name" json:"name"`
	Description string  `db:"description" json:"description"`
	Price       float64 `db:"price" json:"price"`
	ImageURL    string  `db:"image_url" json:"image_url"`
	Creator_id  int		`db:"creator_id" json:"creator_id"`
	Username	string	`db:"username" json:"username"`
	Email  		string	`db:"email" json:"email"`
}

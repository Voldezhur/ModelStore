package models

// ErrorResponse представляет структуру ошибки
type ItemFilter struct {
	NameFilter string `json:"name_filter" example:""`
	Sort       string `json:"sort" example:""`
}

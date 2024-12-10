package models

// ErrorResponse представляет структуру ошибки
type ErrorResponse struct {
	Error   string `json:"error" example:"Некорректные данные"`
	Details string `json:"details,omitempty" example:"Подробности ошибки"`
}

package handlers

import (
	"log"
	"net/http"
	"shopApi/internal/models"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/jmoiron/sqlx"
)

// Получение списка всех пользователей
func GetUsers(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var users []models.User
		err := db.Select(&users, "SELECT * FROM users")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "Ошибка получения списка пользователей",
				"details": err.Error(), // Логирование деталей ошибки
			})
			return
		}
		c.JSON(http.StatusOK, users)
	}
}

// Получение одного пользователя по его ID
func GetUserById(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		idStr := strings.TrimSpace(c.Param("id"))
		if idStr == "" {
			log.Println("Параметр id пуст")
			c.JSON(http.StatusBadRequest, gin.H{"error": "ID пользователя отсутствует"})
			return
		}
		log.Printf("Полученный параметр idStr: '%s'", idStr)

		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID пользователя"})
			return
		}
		var user models.User
		err = db.Get(&user, "SELECT * FROM users WHERE user_id = $1", id)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			return
		}
		c.JSON(http.StatusOK, user)
	}
}

// Получение одного пользователя по его имени пользователя
func GetUserByUsername(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		username := strings.TrimSpace(c.Param("username"))
		if username == "" {
			log.Println("Параметр username пуст")
			c.JSON(http.StatusBadRequest, gin.H{"error": "Имя пользователя отсутствует"})
			return
		}
		log.Printf("Полученный параметр username: '%s'", username)

		var user models.User
		err := db.Get(&user, "SELECT * FROM users WHERE username = $1", username)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			return
		}
		c.JSON(http.StatusOK, user)
	}
}

// Получение одного пользователя по его электронной почте
func GetUserByEmail(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		email := strings.TrimSpace(c.Param("email"))
		if email == "" {
			log.Println("Параметр email пуст")
			c.JSON(http.StatusBadRequest, gin.H{"error": "Email отсутствует"})
			return
		}
		log.Printf("Полученный параметр email: '%s'", email)

		var user models.User
		err := db.Get(&user, "SELECT * FROM users WHERE email = $1", email)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Пользователь не найден"})
			return
		}
		c.JSON(http.StatusOK, user)
	}
}

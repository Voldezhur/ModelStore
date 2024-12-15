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

// GetCart godoc
// @Summary Get all cart
// @Description Получить список корзин
// @Tags Cart
// @Produce json
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
// @Router /carts [get]
func GetCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Получаем ID из параметров маршрута
		idStr := c.Param("id")
		log.Println("Полученный параметр idStr:", idStr)

		// Убираем лишние пробелы
		idStr = strings.TrimSpace(idStr)

		// Преобразуем ID в целое число
		id, err := strconv.Atoi(idStr)
		if err != nil {
			log.Println("Ошибка преобразования idStr в int:", err)
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID пользователя"})
			return
		}

		// Выполняем запрос к базе данных
		var cartUser []models.Cart
		err = db.Select(&cartUser, "SELECT * FROM cart WHERE user_id = $1", id)
		if err != nil {
			log.Println("Ошибка запроса к базе данных:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения корзины"})
			return
		}

		// Отправляем ответ
		c.JSON(http.StatusOK, cartUser)
	}
}

// AddCart godoc
// @Summary Get all cart
// @Description Добаление нового продукта в корзину
// @Tags Cart
//
//	@Produce		json
//	@Param			id	path		int	true	"Cart ID"
//	@Success		200	{object}	models.Cart
//
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
//
//	@Router			/carts/{id} [post]
func AddToCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		var item struct {
			ProductID int `json:"product_id"`
			Quantity  int `json:"quantity"`
		}
		if err := c.ShouldBindJSON(&item); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}
		_, err := db.Exec("INSERT INTO Cart (user_id, product_id, quantity) VALUES ($1, $2, $3) ON CONFLICT (user_id, product_id) DO UPDATE SET quantity = $3",
			userId, item.ProductID, item.Quantity)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления в корзину"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Товар добавлен в корзину"})
	}
}

func RemoveFromCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		productId := c.Param("productId")
		_, err := db.Exec("DELETE FROM Cart WHERE user_id = $1 AND product_id = $2", userId, productId)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка удаления из корзины"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Товар удален из корзины"})
	}
}

func ClearCart(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		userId := c.Param("userId")
		_, err := db.Exec("DELETE FROM Cart WHERE user_id = $1", userId)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка очистки корзины"})
			return
		}
		c.JSON(http.StatusOK, gin.H{"message": "Корзина очищена"})
	}
}

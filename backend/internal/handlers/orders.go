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

// GetOrders godoc
// @Summary Get user orders
// @Description Retrieves all orders for a specific user.
// @Tags Orders
// @Produce json
// @Param id path int true "User ID"
// @Success 200 {array} models.Order
// @Failure 400 {object} ErrorResponse "Invalid User ID"
// @Failure 500 {object} ErrorResponse "Internal server error"
// @Router /orders/{id} [get]
func GetOrders(db *sqlx.DB) gin.HandlerFunc {
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
		var orders []models.Order
		err = db.Select(&orders, "SELECT * FROM orders WHERE user_id = $1", id)

		if err != nil {
			log.Println("Ошибка запроса к базе данных:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка получения заказов"})
			return
		}

		// Отправляем ответ
		c.JSON(http.StatusOK, orders)
	}
}

// CreateOrder godoc
// @Summary Create a new order
// @Description Adds a new order for a user, including products in the order.
// @Tags Orders
// @Accept json
// @Produce json
// @Param order body models.Order true "Order details"
// @Success 201 {object} models.Order
// @Failure 400 {object} ErrorResponse "Invalid request data"
// @Failure 500 {object} ErrorResponse "Internal server error"
// @Router /orders [post]
func CreateOrder(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var order models.Order

		// Привязываем данные из тела запроса
		if err := c.ShouldBindJSON(&order); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		// Начинаем транзакцию
		tx, err := db.Beginx()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка инициализации транзакции"})
			return
		}

		// Вставляем заказ в таблицу orders
		queryOrder := `
			INSERT INTO orders (user_id, total, status)
			VALUES (:user_id, :total, :status)
			RETURNING order_id
		`
		rows, err := tx.NamedQuery(queryOrder, &order)
		if err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления заказа"})
			return
		}
		if rows.Next() {
			rows.Scan(&order.OrderID) // Получаем ID нового заказа
		}
		rows.Close()

		// Вставляем товары в таблицу order_products
		queryProducts := `
			INSERT INTO order_products (order_id, product_id, quantity)
			VALUES (:order_id, :product_id, :quantity)
		`
		for _, product := range order.Products {
			productData := map[string]interface{}{
				"order_id":   order.OrderID,
				"product_id": product.ProductID,
				"quantity":   product.Stock, // Здесь quantity (например, 1, 2 и т.д.) нужно передать из тела запроса
			}
			_, err := tx.NamedExec(queryProducts, productData)
			if err != nil {
				tx.Rollback()
				c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления товаров к заказу"})
				return
			}
		}

		// Завершаем транзакцию
		if err := tx.Commit(); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка сохранения заказа"})
			return
		}

		// Отправляем ответ
		c.JSON(http.StatusCreated, order)
	}
}

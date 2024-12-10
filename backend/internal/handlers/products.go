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

// Получение списка всех продуктов

// GetProducts godoc
// @Summary Get all products
// @Description Retrieves a list of all available products from the database.
// @Tags Products
// @Produce json
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
// @Router /products [get]
func GetProducts(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var products []models.Product
		err := db.Select(&products, "SELECT * FROM product")
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   "Ошибка получения списка продуктов",
				"details": err.Error(), // Логирование деталей ошибки
			})
			return
		}
		c.JSON(http.StatusOK, products)
	}
}

// Получение одного продукта по его ID

// GetProduct godoc
//
//	@Summary		Get product by ID
//	@Description	Retrieves a single product by its ID.
//	@Tags			Products
//	@Produce		json
//	@Param			id	path		int	true	"Product ID"
//	@Success		200	{object}	models.Product
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
//	@Router			/products/{id} [get]
func GetProduct(db *sqlx.DB) gin.HandlerFunc {
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
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID продукта"})
			return
		}
		var product models.Product
		// err = db.Get(&product, "SELECT * FROM Product WHERE product_id = $1", id)
		err = db.Get(&product, "select p.product_id, p.name, p.description, p.price, p.image_url, p.creator_id, u.username, u.email from product p join users u on p.creator_id = u.user_id where product_id = $1", id)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "Продукт не найден"})
			return
		}
		c.JSON(http.StatusOK, product)
	}
}

// Создание нового продукта
// CreateProduct godoc
//	@Summary		Create a new product
//	@Description	Adds a new product to the database.
//	@Tags			Products
//	@Accept			json
//	@Produce		json
//	@Param			product	body		models.Product	true	"Product details"
//	@Success		201		{object}	models.Product
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
//	@Router			/products [post]
func CreateProduct(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		var product models.Product
		if err := c.ShouldBindJSON(&product); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		query := `INSERT INTO Product (name, description, price, image_url, creator_id) 
                  VALUES (:name, :description, :price, :image_url, :creator_id) RETURNING product_id`

		rows, err := db.NamedQuery(query, &product)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка добавления продукта"})
			return
		}
		if rows.Next() {
			rows.Scan(&product.ProductID) // Присваиваем ID нового продукта
		}
		rows.Close()

		c.JSON(http.StatusCreated, product)
	}
}

// Обновление существующего продукта по его ID

// UpdateProduct godoc
//
//	@Summary		Update product by ID
//	@Description	Updates the details of an existing product by its ID.
//	@Tags			Products
//	@Accept			json
//	@Produce		json
//	@Param			id		path		int				true	"Product ID"
//	@Param			product	body		models.Product	true	"Updated product details"
//	@Success		200		{object}	models.Product
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
//	@Router			/products/{id} [put]
func UpdateProduct(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		idStr := c.Param("id")
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID продукта"})
			return
		}

		var product models.Product
		if err := c.ShouldBindJSON(&product); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректные данные"})
			return
		}

		product.ProductID = id
		query := `UPDATE Product SET name = :name, description = :description, price = :price, 
                  stock = :stock, image_url = :image_url WHERE product_id = :product_id`

		_, err = db.NamedExec(query, &product)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка обновления продукта"})
			return
		}

		c.JSON(http.StatusOK, product)
	}
}

// Удаление продукта по его ID

// DeleteProduct godoc
//
//	@Summary		Delete product by ID
//	@Description	Deletes a product from the database by its ID.
//	@Tags			Products
//	@Produce		json
//	@Param			id	path		int	true	"Product ID"
//	@Success		200	{object}	map[string]string
// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse
//	@Router			/products/{id} [delete]
func DeleteProduct(db *sqlx.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		idStr := c.Param("id")
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Некорректный ID продукта"})
			return
		}

		_, err = db.Exec("DELETE FROM Product WHERE product_id = $1", id)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка удаления продукта"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"message": "Продукт успешно удален"})
	}
}

package main

import (
	"log"
	"shopApi/internal/handlers"
	"shopApi/pkg/db"

	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"github.com/gin-gonic/gin"

	_ "shopApi/docs" // Путь к сгенерированной документации
)

//	@title			Shop API
//	@version		1.0
//	@description	API для работы с заказами и продуктами.
//	@termsOfService	http://example.com/terms/

//	@contact.name	API Support
//	@contact.url	http://www.example.com/support
//	@contact.email	support@example.com

//	@license.name	Apache 2.0
//	@license.url	http://www.apache.org/licenses/LICENSE-2.0.html

//	@host		localhost:8080
//	@BasePath	/

// @Failure 400 {object} models.ErrorResponse
// @Failure 500 {object} models.ErrorResponse

func main() {
	// Подключаемся к базе данных
	db, err := db.ConnectDB()
	if err != nil {
		log.Fatal("Ошибка подключения к БД:", err)
	}

	router := gin.Default()

	// Swagger UI по адресу /swagger/index.html
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// Роуты для продуктов
	router.GET("/products", handlers.GetProducts(db))
	router.GET("/products/:id", handlers.GetProduct(db))
	router.POST("/products", handlers.CreateProduct(db))
	router.PUT("/products/:id", handlers.UpdateProduct(db))
	router.DELETE("/products/:id", handlers.DeleteProduct(db))

	// Роуты для корзины
	router.GET("/cart/:id", handlers.GetCart(db))
	router.POST("/cart/:userId", handlers.AddToCart(db))
	router.DELETE("/cart/:userId/:productId", handlers.RemoveFromCart(db))
	router.DELETE("/cart/clear/:userId", handlers.ClearCart(db))

	// Роуты для избранного
	router.GET("/favourites/:id", handlers.GetFavourites(db))
	router.GET("/favourites/check/:userId/:productId", handlers.CheckIsFavourite(db))
	router.POST("/favourites/:userId", handlers.AddToFavourites(db))
	router.DELETE("/favourites/:userId/:productId", handlers.RemoveFromFavourites(db))

	// Роуты для заказов
	router.GET("/orders/:id", handlers.GetOrders(db))
	router.POST("/orders/:user_id", handlers.CreateOrder(db))

	// Роуты для пользователей
	router.GET("/users", handlers.GetUsers(db))
	router.GET("/users/:id", handlers.GetUserById(db))
	router.GET("/users/username/:username", handlers.GetUserByUsername(db))
	router.GET("/users/email/:email", handlers.GetUserByEmail(db))
	router.POST("/users", handlers.CreateUser(db))

	// Запуск сервера
	router.Run(":8080")
}

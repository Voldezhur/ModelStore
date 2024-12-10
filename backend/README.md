## Для полноценной работы необходимо установить postres 

## Создание БД магазина на Postgres

### Для создание БД магазина вам необходимо выполнить данный скрипт на создание нужных таблиц

```postgres
CREATE DATABASE shop;

-- Переключаемся на базу данных shop
\c shop;

-- Создаем таблицу для пользователей
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создаем таблицу для продуктов
CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    image_url VARCHAR(255)
);

-- Создаем таблицу для избранных товаров
CREATE TABLE Favorites (
    favorite_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    product_id INT REFERENCES Product(product_id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id) -- чтобы один пользователь не мог добавить один и тот же продукт несколько раз
);

-- Создаем таблицу для корзины
CREATE TABLE Cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE,
    product_id INT REFERENCES Product(product_id) ON DELETE CASCADE,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id) -- чтобы один пользователь не мог добавить один и тот же продукт несколько раз
);

-- Создаем таблицу для заказов
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица для продуктов в заказе (order_products)


CREATE TABLE order_products (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

```

**Для подключения к БД в моем случае используется логин 'postgres' и пароль '12345'. У вас данные параметры могут отличаться.**

**Изменить параметры подключения можно в файле database.go**

Только после создания базы данных можно запускать REST API..

**Для запуска проекта используйте команду `go run cmd/shop/main.go`**

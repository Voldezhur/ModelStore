# Программирование корпоративных систем практика 10 Журавлев Владимир ЭФБО-02-22

В ходе практики была реализована база данных, с помощью которой осуществляется работа всего приложения

Схема БД:
![alt text](images/image.png)

## Таблицы БД:
Корзины
![alt text](images/image-1.png)
Любимые товары
![alt text](images/image-2.png)
Товары в заказе
![alt text](images/image-3.png)
Заказы
![alt text](images/image-4.png)
Продукты
![alt text](images/image-5.png)
Пользователи
![alt text](images/image-6.png)

В таблице польователей не хранится пароль пользователя, за это отвечает firebase. Эта таблица нужна была для связи firebase с postgres

Взаимодействие фронтенда с БД происходит посредством бекенда написанного на Golang, а также Dio для Flutter. Этот функционал на фронтенде описан в файле utilities/api_handling/api_service.dart

Реализованы основные функции, такие как добавление и удаление товаров, добавление товаров в избранное, добавление товаров в корзину, заказ

Ниже показаны скриншоты работы приложения с БД с описанием

Регистрация нового пользователя - добавляет запись о пользователе в БД
![alt text](images/image-7.png)

Профиль пользователя - после авторизации подгружаются актуальные данные о пользователе
![alt text](images/image-8.png)

Список всех товаров подгружается с БД
![alt text](images/image-9.png)

Страница товара - информация подгружается по id товара
![alt text](images/image-10.png)

Добавление новой модели
![alt text](images/image-11.png)

Список после добавления
![alt text](images/image-12.png)

Список избранных моделей после добавления модели в избранное
![alt text](images/image-13.png)

Список избранных моделей после того, как убрали модель из избранных
![alt text](images/image-14.png)

Добавление модели в корзину
![alt text](images/image-15.png)

Удаление модели из корзины
![alt text](images/image-16.png)

Запись о новом заказе в БД
![alt text](images/image-17.png)

Продукты в новом заказе
![alt text](images/image-18.png)
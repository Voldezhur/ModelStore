import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:modelstore/widgets/items_display/item_card.dart';

// select *, (case when (product_id in (select product_id from favourites where user_id = 1)) then true else false end) as isFavourite from product;

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  late Future<List<Item>> itemList; // Список товаров
  String title = 'Главная'; // Заголовок AppBar

  @override
  void initState() {
    // Получаем список всех товаров из бекенда
    itemList = ApiService().getFavourites(currentUser!.userId);

    super.initState();
  }

  void _removeItem(id) async {
    // Удаление продукта из бд по айди
    await ApiService().deleteProductById(id);

    setState(() {
      // Подгрузка обновленных данных из бд
      itemList = ApiService().getFavourites(currentUser!.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // Используем FutureBuilder для удобной работы
      body: FutureBuilder<List<Item>>(
        future: itemList,
        builder: (context, snapshot) {
          // В зависимости от статуса подгрузки данных выводим:
          // Если ожидание - индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Если ошибка - ошибку
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Если полученные данные пустые - соответствующее оповещение
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Пусто 🤷\n Моделей не найдено",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          }

          // На этом этапе какие-то данные в snapshot точно есть
          // Записываем эти данные в список и строим GridView
          final modelList = snapshot.data!;

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.height / 1.2),
              ),
              itemCount: modelList.length,
              itemBuilder: (BuildContext context, int index) {
                // Передаем полученный список и индекс даннйо карточки для отрисовки
                // Отрисовка карточек не отправляет дополнительных запросов
                // Запросы для отдельных товаров отправляются только на странице самого товара
                return ItemCard(
                    item: modelList[index], removeItem: _removeItem);
              });
        },
      ),
    );
  }
}

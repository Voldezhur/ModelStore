import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/widgets/items_display/item_card.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.itemList, required this.title});

  final Future<List<Item>> itemList;
  final String title;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    var items = widget.itemList; // Future, полученный из бекенда

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Используем FutureBuilder для удобной работы
      body: FutureBuilder<List<Item>>(
        future: items,
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
                  itemIndex: index,
                  itemList: modelList,
                );
              });
        },
      ),
    );
  }
}

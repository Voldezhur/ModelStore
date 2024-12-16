import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/pages/items/item_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.removeItem,
    required this.addToCart,
  });

  final Item item;
  final Function removeItem;
  final Function addToCart;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isFavourite = false;

  // Функция для перехода на страницу товара
  // В товар подается id товара
  // Подгрузка данных происходит уже на странице самого товара
  void _goToItemPage() async {
    final isDeleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
          itemId: widget.item.productId,
        ),
      ),
    );

    if (isDeleted == true) {
      widget.removeItem(widget.item.productId);
    }
  }

  // Проверка, является ли товар любимым
  void _checkIsFavourite() async {
    final res = await ApiService().checkIsFavourite(currentUser!.userId, widget.item.productId);

    setState(() {
      isFavourite = res;
    });
  }

  // Тогглим статус избранного для продукта на карточке
  void _toggleFavourite() {
    if (isFavourite) {
      ApiService().removeFavourite(widget.item.productId);
    } else {
      ApiService().addFavourite(widget.item.productId);
    }

    setState(() {
      isFavourite = !isFavourite;
    });
  }

  // Когда карточка товара появляется на экране,
  // Проверяем, является ли он избранным
  // Отправляем запрос на бекенд
  @override
  void initState() {
    _checkIsFavourite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => _goToItemPage(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Контейнер верхней части
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 2),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  // Картинка
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: SizedBox(
                      height: 120,
                      child: Image.network(
                        widget.item.imageUrl,
                      ),
                    ),
                  ),
                ),
                // Контейнер описания
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Название
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          widget.item.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Стоимость: ${widget.item.price}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Кнопки
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Избранное
                          IconButton(
                            onPressed: _toggleFavourite,
                            icon: Icon(
                              isFavourite ? Icons.favorite : Icons.favorite_border,
                            ),
                          ),
                          // Добавить в корзину
                          IconButton(onPressed: () => widget.addToCart(widget.item.productId), icon: const Icon(Icons.add_shopping_cart))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

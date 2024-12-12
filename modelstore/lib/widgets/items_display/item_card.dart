import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/pages/items/item_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
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
      setState(() {
        ApiService().deleteProductById(widget.item.productId);
      });
    }
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Картинка
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 2))),
                  padding: const EdgeInsets.all(6),
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: Image.network(
                    widget.item.imageUrl,
                    height: 100,
                  ),
                ),
                // Колонка описания
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
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      // ID создателя
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            widget.item.creatorId.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Стоимость: ${widget.item.price}",
                        style: const TextStyle(color: Colors.white),
                      ),
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

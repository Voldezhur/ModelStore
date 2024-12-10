import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/pages/items/item_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.itemList, required this.itemIndex});

  final List<Item> itemList;
  final int itemIndex;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Функция для перехода на страницу товара
  // В товар подается id товара
  // Подгрузка данных происходит уже на странице самого товара
  void _goToItemPage() async {
    bool isDeleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(
          itemId: widget.itemList[widget.itemIndex].productId,
        ),
      ),
    );

    if (isDeleted) {
      setState(() {
        ApiService()
            .deleteProductById(widget.itemList[widget.itemIndex].productId);
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
                    widget.itemList[widget.itemIndex].imageUrl,
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
                          widget.itemList[widget.itemIndex].name,
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
                            widget.itemList[widget.itemIndex].creatorId
                                .toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Стоимость: ${widget.itemList[widget.itemIndex].price}",
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

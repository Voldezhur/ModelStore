import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/widgets/items_display/item_card.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.itemList});

  final Future<List<Item>> itemList;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    var items = widget.itemList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('список моделей'),
      ),
      body: FutureBuilder<List<Item>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Пусто 🤷\n Моделей не найдено",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          }

          final modelList = snapshot.data!;

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (MediaQuery.of(context).size.width) /
                    (MediaQuery.of(context).size.height / 1.2),
              ),
              itemCount: modelList.length,
              itemBuilder: (BuildContext context, int index) {
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

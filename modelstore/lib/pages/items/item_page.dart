import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key, required this.itemId});

  final int itemId; // ID товара
  // По ID отправляется запрос к бекенду
  // С полученной информацией отрисовывается страница товара

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<Item> item; // Товар, страницу которого отрисовываем

  // При загрузке виджета получем товар из бекенда
  @override
  void initState() {
    super.initState();
    item = ApiService().getProductById(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    // Используем FutureBuilder для упрощения работы
    return FutureBuilder(
      future: item,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No such item'));
        }

        final item = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
          ),
          body: Column(
            children: [
              item.creatorId == currentUser!.userId
                  ? ElevatedButton(
                      onPressed: () {},
                      child: const Text('Удалить'),
                    )
                  : Container(),
              Text(item.creatorUsername),
            ],
          ),
        );
      },
    );
  }
}

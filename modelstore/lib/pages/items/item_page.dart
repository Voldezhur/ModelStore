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
            actions: item.creatorId == currentUser!.userId
                ? [
                    IconButton(
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.delete),
                    ),
                  ]
                : [],
          ),
          body: Center(
            child: Column(
              children: [
                // item.creatorId == currentUser!.userId
                //     ? ElevatedButton(
                //         onPressed: () => Navigator.pop(context, true),
                //         child: const Text('Удалить'),
                //       )
                //     : Container(),
                // Картинка
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  margin: const EdgeInsets.only(bottom: 32),
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Image.network(item.imageUrl),
                ),
                // Создатель
                Text(
                  'Создатель: ${item.creatorUsername}',
                  style: const TextStyle(fontSize: 14),
                ),
                // Описание
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 21),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

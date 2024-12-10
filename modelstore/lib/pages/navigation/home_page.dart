import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:modelstore/widgets/items_display/item_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    late Future<List<Item>> itemList;
    const String title = 'Главная';

    // Получаем список из бекенда
    itemList = ApiService().getProducts();

    return ItemList(itemList: itemList, title: title);
  }
}

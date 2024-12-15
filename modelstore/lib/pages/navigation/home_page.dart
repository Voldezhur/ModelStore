import 'package:flutter/material.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/pages/items/add_item_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:modelstore/widgets/items_display/item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Item>> itemList; // Список товаров
  String title = 'Главная'; // Заголовок AppBar

  var searchController = TextEditingController();

  String search = '';
  String filter = '';

  @override
  void initState() {
    // Получаем список всех товаров из бекенда
    itemList = ApiService().getProducts();

    super.initState();
  }

  // Функция добавления продукта
  void _addItem(item) async {
    // Добавление продукта в бд
    // item - JSON объект
    await ApiService().addProduct(item);

    setState(() {
      // Подгрузка обновленных данных из бд
      itemList = ApiService().getProducts();
    });
  }

  void _removeItem(id) async {
    // Удаление продукта из бд по айди
    await ApiService().deleteProductById(id);

    setState(() {
      // Подгрузка обновленных данных из бд
      itemList = ApiService().getProducts();
    });
  }

  // Добавление продукта в корзину
  void _addToCart(productId) {
    ApiService().addtoCart(
      {
        'product_id': productId,
        'quantity': 1,
      },
    );
  }

  // Осуществление поиска и сортировки
  void _getProductsFiltered() {
    setState(() {
      search = searchController.text;
      itemList = ApiService().getProductsFiltered(search, filter);
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

          return Column(
            children: [
              // Поиск и сортировка
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Строка поиска
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: 'Поиск...',
                            hintFadeDuration: Duration(milliseconds: 200),
                          ),
                        ),
                      ),
                      // Кнопка поиска
                      IconButton(
                        onPressed: _getProductsFiltered,
                        icon: const Icon(Icons.search),
                      ),
                      // Кнопка сортировки - открывает меню
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 1,
                            child: Text('По стоимости по возрастанию'),
                          ),
                          const PopupMenuItem(
                            value: 2,
                            child: Text('По стоимости по убыванию'),
                          ),
                          const PopupMenuItem(
                            value: 3,
                            child: Text('В алфавитном порядке'),
                          ),
                          const PopupMenuItem(
                            value: 4,
                            child: Text('Сбросить фильтр'),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              filter = 'price asc';
                              break;
                            case 2:
                              filter = 'price desc';
                              break;
                            case 3:
                              filter = 'name';
                              break;
                            default:
                              filter = '';
                              break;
                          }

                          _getProductsFiltered();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Карточки товаров
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (MediaQuery.of(context).size.width) /
                          (MediaQuery.of(context).size.height / 1.2),
                    ),
                    itemCount: modelList.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Передаем предмет для отрисовки
                      return ItemCard(
                        item: modelList[index],
                        removeItem: _removeItem,
                        addToCart: _addToCart,
                      );
                    }),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItemPage(),
            ),
          );

          if (result != null) {
            _addItem(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

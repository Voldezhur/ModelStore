import 'package:flutter/material.dart';
import 'package:modelstore/models/cart_item.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:modelstore/widgets/items_display/cart_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartItem>> cart;

  // Удаление модели из корзины
  void _removeItem(itemId) async {
    await ApiService().removeCartItem(itemId);

    setState(() {
      cart = ApiService().getCart();
    });
  }

  // Увеличение / уменьшение числа моделей в корзине
  void _incrementItem(itemId, amount, adding) async {
    await ApiService()
        .incrementCartItem({"product_id": itemId, "quantity": amount}, adding);

    // setState(() {
    //   cart = ApiService().getCart();
    // });
  }

  @override
  void initState() {
    cart = ApiService().getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      // Используем FutureBuilder для удобной работы
      body: FutureBuilder<List<CartItem>>(
        future: cart,
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
                "Пусто 🤷\n Нет моделей в корзине",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          }

          // На этом этапе какие-то данные в snapshot точно есть
          // Записываем эти данные в список и строим GridView
          final cartList = snapshot.data!;

          return Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CartCard(
                      cartItem: cartList[index],
                      removeItem: _removeItem,
                      incrementItem: _incrementItem,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).disabledColor,
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Суммарная стоимость корзины: ${cartList.fold(0, (sum, item) => sum + (item.item.price * item.amount))}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
    var isDeleted = await ApiService().incrementCartItem(
      {
        "product_id": itemId,
        "quantity": amount,
      },
      adding,
    );

    setState(() {
      if (isDeleted) {
        cart = ApiService().getCart();
      }
    });
  }

  // Создать заказ
  void _placeOrder(List<CartItem> cartList) async {
    // Суммарная стоимость заказа
    var total = cartList.fold(
      0,
      (sum, cartItem) => sum + cartItem.item.price * cartItem.amount,
    );

    // Список продуктов в заказе
    var items = [];
    for (var i in cartList) {
      items.add({
        'product_id': i.item.productId,
        'stock': i.amount,
      });
    }

    // Посылаем запрос на бек
    await ApiService().placeOrder(total, 'pending', items);
    // Очищаем корзину
    await ApiService().clearCart();

    setState(() {
      cart = ApiService().getCart();
    });
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
          // Записываем эти данные в список и строим UI
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
                  child: InkWell(
                    onTap: () => _placeOrder(cartList),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).disabledColor,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Оставить заказ на сумму: ${cartList.fold(0, (sum, item) => sum + (item.item.price * item.amount))}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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

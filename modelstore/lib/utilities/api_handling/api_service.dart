import 'package:dio/dio.dart';
import 'package:modelstore/models/cart_item.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';

class ApiService {
  final Dio dio = Dio();
  final url = 'http://195.43.142.156:8080';

  // Получить список всех продуктов
  // Возвращает список объектов класса Item
  Future<List<Item>> getProducts() async {
    try {
      final response = await dio.get('$url/products');
      if (response.statusCode == 200) {
        // Получаем ответ с с бекенда
        var res = response.data;

        // Переводим полученный JSON в список продуктов
        // Если получаем null - возвращаем пустой список
        List<Item> items = res == null ? [] : (response.data as List).map((item) => Item.fromJson(item)).toList();

        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Получить список всех продуктов с фильтрами
  // Возвращает список объектов класса Item
  Future<List<Item>> getProductsFiltered(nameFilter, sort) async {
    try {
      final response = await dio.get(
        '$url/products/filtered',
        data: {'name_filter': nameFilter, 'sort': sort},
      );
      if (response.statusCode == 200) {
        // Получаем ответ с бекенда
        var res = response.data;

        // Переводим полученный JSON в список продуктов
        // Если получаем null - возвращаем пустой список
        List<Item> items = res == null ? [] : (response.data as List).map((item) => Item.fromJson(item)).toList();

        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Получить продукт по ID
  // Возвращает объект класса Item
  Future<Item> getProductById(id) async {
    try {
      final response = await dio.get('$url/products/$id');
      if (response.statusCode == 200) {
        Item item = Item.fromJson(response.data);
        return item;
      } else {
        throw Exception('Failed to load item');
      }
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }

  // Удалить продукт по ID
  // На вход получает ID продукта
  Future<void> deleteProductById(id) async {
    try {
      final response = await dio.delete('$url/products/$id');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete item $id, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not delete item: $e');
    }
  }

//   // Редактировать книгу по ID
//   // Получает на вход ID книги и JSON объект, подогнанный под формат для бекенда
//   void updateBookById(id, newItem) async {
//     try {
//       final response = await dio.put(
//         'http://10.0.2.2:8080/products/update/$id',
//         data: newItem,
//       );
//       if (response.statusCode != 200) {
//         throw Exception(
//           'Failed to update item $id, status code ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       throw Exception('could not update item: $e');
//     }
//   }

  // Добавить новый продукт
  // Получает на вход JSON объект, подогнанный под формат для бекенда
  Future<void> addProduct(newItem) async {
    try {
      final response = await dio.post(
        '$url/products',
        data: newItem,
      );
      if (response.statusCode != 201) {
        throw Exception(
          'Failed to add item, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }

  // Добавить пользователя
  void addUser(newUser) async {
    try {
      final response = await dio.post(
        '$url/users',
        data: newUser,
      );
      if (response.statusCode != 201) {
        throw Exception(
          'Failed to add item, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }

  // Найти пользователя по имени пользователя
  Future<User> getUserByUsername(username) async {
    try {
      final response = await dio.get('$url/users/username/$username');
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        return user;
      } else {
        throw Exception('Failed to load item');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Найти пользователя по электронной почте
  Future<User> getUserByEmail(email) async {
    try {
      final response = await dio.get('$url/users/email/$email');
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        return user;
      } else {
        throw Exception('Failed to load item');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Получить список избранных товаров по ID пользователя
  // Возвращает список объектов класса Item
  Future<List<Item>> getFavourites(id) async {
    try {
      final response = await dio.get('$url/favourites/$id');
      if (response.statusCode == 200) {
        // Получаем ответ с с бекенда
        var res = response.data;

        // Переводим полученный JSON в список продуктов
        // Если получаем null - возвращаем пустой список
        List<Item> items = res == null ? [] : (response.data as List).map((item) => Item.fromJson(item)).toList();

        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Проверить, является ли продукт избранным у пользователя
  // Возвращает bool
  Future<bool> checkIsFavourite(userId, productId) async {
    try {
      final response = await dio.get('$url/favourites/check/$userId/$productId');
      if (response.statusCode == 200) {
        // Получаем ответ с с бекенда
        var res = response.data;

        return res;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Добавить продукт в любимое
  void addFavourite(productId) async {
    try {
      final response = await dio.post(
        '$url/favourites/${currentUser!.userId}',
        data: {"product_id": productId},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to add item to favourites, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }

  // Удалить продукт из любимого
  void removeFavourite(productId) async {
    try {
      final response = await dio.delete('$url/favourites/${currentUser!.userId}/$productId');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove item from favourites, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not remove item: $e');
    }
  }

  // Получить список продуктов из корзины
  Future<List<CartItem>> getCart() async {
    try {
      final response = await dio.get('$url/cart/${currentUser!.userId}');

      if (response.statusCode == 200) {
        // Получаем ответ с с бекенда
        var res = response.data;

        // Переводим полученную информацию в набор объектов {product_id, quantity}
        // Если получаем null - возвращаем пустой список
        List items = res == null
            ? []
            : (response.data as List)
                .map((item) => {
                      item['product_id'],
                      item['quantity'],
                    })
                .toList();

        List<CartItem> cart = [];
        // Для каждого объекта отправляем запрос на бекенд,
        // Чтобы получить продукт
        // До этого у нас есть только id продукта
        // После этого у нас будет сам объект
        for (var i in items) {
          // i.first - id продукта
          var cartItem = await getProductById(i.first);
          // i.last - количество продукта в корзине
          cart.add(CartItem(cartItem, i.last));
        }

        return cart;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Удаление продукта из корзины
  Future<void> removeCartItem(itemId) async {
    try {
      var response = await dio.delete('$url/cart/${currentUser!.userId}/$itemId');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove item from cart, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not remove item: $e');
    }
  }

  // Увеличение или уменьшение количества продукта в корзине
  // item: {product_id, quantity}
  // adding: bool. true - увеличение, false - уменьшение
  // Возвращает true, если объект был удален и false, если нет
  Future<bool> incrementCartItem(item, adding) async {
    try {
      // Проверка увеличение / уменьшение
      int amount;
      if (adding) {
        amount = item['quantity'] + 1;
      } else {
        amount = item['quantity'] - 1;
      }

      if (amount <= 0) {
        await removeCartItem(item['product_id']);
        return true;
      }

      var response = await dio.post(
        '$url/cart/${currentUser!.userId}',
        data: {'product_id': item['product_id'], 'quantity': amount},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to increment item, status code ${response.statusCode}',
        );
      }
      return false;
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }

  // Добавление продукта в корзину
  // item: {product_id, quantity}
  Future<void> addtoCart(item) async {
    try {
      var response = await dio.post(
        '$url/cart/${currentUser!.userId}',
        data: item,
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to add item to cart, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }

  // Удаление продукта из корзины
  Future<void> clearCart() async {
    try {
      var response = await dio.delete('$url/cart/clear/${currentUser!.userId}');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to clear cart, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not clear cart: $e');
    }
  }

  // Добавление заказа
  // products: [{"product_id", "stock"}]
  Future<void> placeOrder(total, status, products) async {
    try {
      var response = await dio.post(
        '$url/orders/${currentUser!.userId}',
        data: {"user_id": currentUser!.userId, "total": total, "status": status, "products": products},
      );
      if (response.statusCode != 201) {
        throw Exception(
          'Failed to place order, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not place order: $e');
    }
  }
}

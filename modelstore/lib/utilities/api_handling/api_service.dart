import 'package:dio/dio.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';

class ApiService {
  final Dio dio = Dio();
  final url = 'http://10.0.2.2:8080';

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
        List<Item> items = res == null
            ? []
            : (response.data as List)
                .map((item) => Item.fromJson(item))
                .toList();

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
        List<Item> items = res == null
            ? []
            : (response.data as List)
                .map((item) => Item.fromJson(item))
                .toList();

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
      final response =
          await dio.get('$url/favourites/check/$userId/$productId');
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
      final response =
          await dio.delete('$url/favourites/${currentUser!.userId}/$productId');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove item from favourites, status code ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('could not add item: $e');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:modelstore/models/item.dart';
import 'package:modelstore/models/user.dart';

class ApiService {
  final Dio dio = Dio();
  final url = 'http://10.0.2.2:8080';

  // Получить список всех книг
  // Возвращает список объектов класса Item
  Future<List<Item>> getProducts() async {
    try {
      final response = await dio.get('$url/products');
      if (response.statusCode == 200) {
        // Переводим полученный JSON в список продуктов
        List<Item> items =
            (response.data as List).map((item) => Item.fromJson(item)).toList();
        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

//   // Получить список любимых книг
//   // Возвращает список объектов класса Item
//   // Тот же метод, что и getBooks(), но с фильтром в конце
//   Future<List<Item>> getFavourites() async {
//     try {
//       final response = await dio.get('http://10.0.2.2:8080/products');
//       if (response.statusCode == 200) {
//         // Переводим полученный JSON в список книг
//         List<Item> items =
//             (response.data as List).map((item) => Item.fromJson(item)).toList();
//         // Выделяем из полученного списка только любимые
//         final favourites = items.where((x) => x.favourite).toList();
//         return favourites;
//       } else {
//         throw Exception('Failed to load items');
//       }
//     } catch (e) {
//       throw Exception('Error fetching items: $e');
//     }
//   }

  // Получить книгу по ID
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

//   // Удалить книгу по ID
//   // На вход получает ID книги
//   void deleteBookById(id) async {
//     try {
//       final response =
//           await dio.delete('http://10.0.2.2:8080/products/delete/$id');
//       if (response.statusCode != 204) {
//         throw Exception(
//           'Failed to delete item $id, status code ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       throw Exception('could not delete item: $e');
//     }
//   }

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

//   // Добавить новую книгу
//   // Получает на вход JSON объект, подогнанный под формат для бекенда
//   void addBook(newItem) async {
//     try {
//       final response = await dio.post(
//         'http://10.0.2.2:8080/products/create',
//         data: newItem,
//       );
//       if (response.statusCode != 200) {
//         throw Exception(
//           'Failed to add item, status code ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       throw Exception('could not add item: $e');
//     }
//   }

  // Добавить пользователя
  void addUser(newUser) async {
    try {
      final response = await dio.post(
        'http://10.0.2.2:8080/users/create',
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
}

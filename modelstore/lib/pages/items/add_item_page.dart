import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  // Контроллеры для ввода текста
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var imageUrlController = TextEditingController();

  // Данные, использующиеся в том случае,
  // Когда пользователь оставил поля пустыми
  String placeholderName = 'placeholder name';
  String placeholderDescription = 'placeholder desc';
  int placeholderPrice = 1;
  String placeholderImageUrl =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

  // Функция для добавления модели в бд
  // Собирает из вводов JSON объект и отсылает к апи
  void _addProduct() {
    // Подготовка данных
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    String imageUrl = imageUrlController.text;

    // Создание JSON объекта
    final item = {
      "name": name == '' ? placeholderName : name,
      "description": description == '' ? placeholderDescription : description,
      "price": price == '' ? placeholderPrice : int.parse(price),
      "image_url": imageUrl == '' ? placeholderImageUrl : imageUrl,
      "creator_id": currentUser!.userId,
    };

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление модели'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(label: Text('Название модели')),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(label: Text('Описание')),
            ),
            TextField(
              controller: priceController,
              decoration:
                  const InputDecoration(label: Text('Стоимость модели')),
            ),
            TextField(
              decoration:
                  const InputDecoration(label: Text('Ссылка на картинку')),
              controller: imageUrlController,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Выставить модель'),
            ),
          ],
        ),
      ),
    );
  }
}

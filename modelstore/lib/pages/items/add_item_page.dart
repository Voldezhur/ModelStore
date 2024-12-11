import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

// name, description, price, image_url

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key, required this.callback});

  final Function callback;

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  // Контроллеры для ввода текста
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var imageUrlController = TextEditingController();

  String placeholderImageUrl =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

  // Функция для добавления модели в бд
  // Собирает из вводов JSON объект и отсылает к апи
  void _addProduct() {
    setState(() {
      // Подготовка данных
      String name = nameController.text;
      String description = descriptionController.text;
      String price = priceController.text;
      String imageUrl = imageUrlController.text;

      // Проверка, что данные корректны
      if (name != '' && description != '' && price != '') {
        ApiService().addProduct({
          "name": name,
          "description": description,
          "price": int.parse(price),
          // Если поле ссылки на картинку пусто - placeholder
          "image_url": imageUrl == '' ? placeholderImageUrl : imageUrl,
          "creator_id": currentUser!.userId,
        });

        widget.callback();

        Navigator.pop(context);
      }
    });
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

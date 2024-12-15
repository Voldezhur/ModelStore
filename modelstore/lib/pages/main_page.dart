import 'package:flutter/material.dart';
import 'package:modelstore/pages/navigation/cart_page.dart';
import 'package:modelstore/pages/navigation/favourite_page.dart';
import 'package:modelstore/pages/navigation/home_page.dart';
import 'package:modelstore/pages/navigation/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Переход между страницами с помощью BottomNavigationBar
  int selectedIndex = 0; // Индекс выбранной страницы

  // Список страниц
  static List<Widget> widgetOptions = <Widget>[
    const HomePage(),
    const FavouritePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  // Переход между страницами
  void _onNavTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Профиль',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

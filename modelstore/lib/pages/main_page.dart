import 'package:flutter/material.dart';
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

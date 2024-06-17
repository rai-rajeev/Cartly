import 'package:cartly/screens/shopkeeperOrdersScreen.dart';
import 'package:cartly/screens/shopkeeperhome.dart';
import 'package:flutter/material.dart';

import 'accepted_orders.dart';


class MainPage extends StatefulWidget {
  // final int currentIndex;
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentIndex = 0;
  // currentI = widget.currentIndex;
  final screens = [
    const ShopkeeperHomePage(),
    const ShopkeeperOrdersScreen(),
    const AcceptedOrdersScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        iconSize: 20,
        selectedFontSize: 16,
        unselectedFontSize: 13,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
            // backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Current Orders',
            // backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Accepted Orders',
            // backgroundColor: Colors.red,
          ),

        ],
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
      ),
    );
  }
}
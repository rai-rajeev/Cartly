import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../widgets/pendCard.dart';

class PendHistory extends StatefulWidget {
  const PendHistory({Key? key}) : super(key: key);

  @override
  State<PendHistory> createState() => _PendHistoryState();
}

class _PendHistoryState extends State<PendHistory> {
  List<Order> Orders = [];

  List<Map<DishInfo, int>> fetchedDishes = [];
  final OrderServ orderServ = OrderServ();
  fetchAcceptedorder() async {
    // print(dishes.length);
    List<Map<String, int>> dishes = [];
    List<Map<DishInfo, int>> fetchedDisheslocal = [];
    Orders = await orderServ.fetchAcceptedOrders(context);
    print(Orders.length);
    print("order length");
    // print('0000');
    for (int i = 0; i < Orders.length; i++) {
      // print("hereee");

      dishes.add(convert().listToMap(Orders[i].items));
      // print(dishes.length);
    }
    print(dishes.length);

    for (int i = 0; i < dishes.length; i++) {
      List<String> dishIdsOrder = [];
      for (String key in dishes[i].keys.toList()) {
        dishIdsOrder.add(key);
      }
      debugPrint('dish');
      List<DishInfo> x =
          await RestaurantServ().fetchDish(context, dishIdsOrder);
      debugPrint('${x.length}');
      Map<DishInfo, int> mp = {};
      for (int j = 0; j < x.length; j++) {
        mp[x[j]] = dishes[i][x[j].id]!;
      }
      fetchedDisheslocal.add(mp);
    }
    // fetchDishesCart();
    if (mounted) {
      setState(() {
        fetchedDishes = fetchedDisheslocal;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAcceptedorder();
    // _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    //fetchAcceptedorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        //color: Colors.teal[100],
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, index) {
                  return PendCard(
                    orders: Orders[index],
                    mp: fetchedDishes[index],
                  ); //(data: widget.stat[index]
                },
                shrinkWrap: true,
                //scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return div;
                },
                itemCount:  fetchedDishes.length),
          ],
        ),
      ),
    );
  }
}

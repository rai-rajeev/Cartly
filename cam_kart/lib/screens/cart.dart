import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../widgets/cartCard.dart';


class cart extends StatefulWidget {
  const cart({Key? key}) : super(key: key);

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  List<Order>? Orders;

  // List<Map<DishInfo, int>> fetchedDishes = [];
  final OrderServ orderServ = OrderServ();
  List<Map<DishInfo, int>> fetchedDishes = [];

  Future<List<Map<DishInfo, int>>> fetchusercart() async {

    List<Map<DishInfo, int>> fetchedDisheslocal = [];
    List<Map<String, int>> dishes = [];

    Orders = await orderServ.fetchUserCart(context);
    print(Orders!.length);
    print('0000');
    for (int i = 0; i < Orders!.length; i++) {
      print("hereee");

      dishes.add(convert().listToMap(Orders![i].items));
      print(dishes.length);
    }

    for (int i = 0; i < dishes.length; i++) {
      List<String> dishIdsOrder = [];
      print("keeyyyy11111111");
      for (String key in dishes[i].keys.toList()) {
        print(key);
        print("keyyyyysssss");
        dishIdsOrder.add(key);
      }
      List<DishInfo> x =
      await RestaurantServ().fetchDish(context, dishIdsOrder);
      Map<DishInfo, int> mp = {};
      for (int j = 0; j < x.length; j++) {
        mp[x[j]] = dishes[i][x[j].id]!;
      }
      fetchedDisheslocal.add(mp);
    }
    setState(() {
      fetchedDishes=fetchedDisheslocal;
    });
    return fetchedDishes;
    // fetchDishesCart();

  }

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchusercart();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: fetchusercart,
        child: ListView(
          physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                  height: 40,
                  child: Center(
                      child: Text(
                        'Your Orders',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ))),
              // (fetchedDishes==null)?Lottie.asset('assets/lottie/empty.json', height: 200, width: 200):
              Lottie.asset('assets/lottie/cart.json', height: 200, width: 200),
              (Orders==null)?const Loader():SizedBox(
                height: MediaQuery.of(context).size.height*(0.52),
                child: ListView.separated(
                  physics:const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemBuilder: (context, index) {

                    print(Orders!.length);
                    // print(Orders![2]);
                    return CartCard(
                      orders: Orders![index],
                      mp: fetchedDishes![index],
                    ); //(data: widget.stat[index]
                  },
                  shrinkWrap: true,
                  //scrollDirection: Axis.vertical,
                  //physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 1,
                    );
                  },
                  itemCount: (fetchedDishes==null)?0:fetchedDishes!.length,
                ),
              )
              

            ]),
      ),
    );
  }
}
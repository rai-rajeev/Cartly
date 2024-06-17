import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../widgets/histCard.dart';
class OrdHistory extends StatefulWidget {
  const OrdHistory({Key? key}) : super(key: key);

  @override
  State<OrdHistory> createState() => _OrdHistoryState();
}

class _OrdHistoryState extends State<OrdHistory> {
  List<Order> Orders=[];
  List<Map<DishInfo, int>> fetchedDishes = [];
  final OrderServ orderServ = OrderServ();
  fetchorderhistory() async {
    List<Map<String, int>> dishes = [];
    List<Map<DishInfo, int>> fetchedDisheslocal = [];
    Orders = await orderServ.fetchCompletedOrders(context);
    Orders.addAll(await orderServ.fetchRejectedOrders(context));
    Orders.sort((a,b)=>DateTime.parse(a.timeOfOrder).compareTo(DateTime.parse(b.timeOfOrder)));
    print(Orders.length);
    print('0000');
    for (int i = 0; i < Orders.length; i++) {
      dishes.add(convert().listToMap(Orders[i].items));
    }

    for (int i = 0; i < dishes.length; i++) {
      List<String> dishIdsOrder = [];
      for (String key in dishes[i].keys.toList()) {
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
    // fetchDishesCart();
    if(mounted) {
      setState(() {
      fetchedDishes=fetchedDisheslocal;
    });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchorderhistory();
    // _tabController = TabController(vsync: this, length: 3);
  }
  @override
  Widget build(BuildContext context) {
    //fetchorderhistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
       // backgroundColor: const Color.fromARGB(255, 239, 102, 105),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {await fetchorderhistory();},
        child: Padding(
          padding: const EdgeInsets.all(10),
          //color: Color.fromARGB(255, 239, 102, 105),
          child: ListView(
            physics: const BouncingScrollPhysics(),

            children: [

              Orders == null
                  ? const Loader()
                  :ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemBuilder: (context, index) {
                    return HistCard(orders: Orders![index],
                      mp: fetchedDishes[index],); //(data: widget.stat[index]
                  },
                  shrinkWrap: true,
                  //scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return div;
                  },
                  itemCount: Orders!.length
              ),


            ],
          ),
        ),
      ),



    );
  }
}
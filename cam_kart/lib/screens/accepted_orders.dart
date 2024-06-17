import 'package:cartly/model/restInfo.dart';
import 'package:cartly/services/restaurantServ.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/constants.dart';
import '../constant/loader.dart';
import '../model/orderInfo.dart';
import '../services/orderServ.dart';
import '../widgets/acceptedOrderCard.dart';
import '../widgets/my_shopkeeper_drawer.dart';

class AcceptedOrdersScreen extends StatefulWidget {
  const AcceptedOrdersScreen({super.key});

  @override
  State<AcceptedOrdersScreen> createState() => _AcceptedOrdersScreenState();
}

class _AcceptedOrdersScreenState extends State<AcceptedOrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Order>? order;
  final OrderServ restServ = OrderServ();
  RestInfo? restaurant;
  fetchacceptedorder() async {
    order = await restServ.fetchAcceptedOrders(context);
    debugPrint('$order');
    final restId=await SharedPrefs().getRestId();
    restaurant=await RestaurantServ().fetchRestaurantsbyID(context,restId!);
    setState(() {});
  }

  // int _selectedIndex = 0;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
  //
  // late TabController _tabController;
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchacceptedorder();
    // _tabController = TabController(vsync: this, length: 3);
  }

  var status = "Ready?";
  // bool _hasBeenPressed = false;
  var items = List<String>.generate(100, (i) => 'Item $i');
  var itemsList = List<List<String>>.generate(
      100, (i) => ['Item $i', 'Item ${(i + 1)}', 'Item ${(i + 2)}']);
  @override
  Widget build(BuildContext context) {
    return order == null
        ? const Loader()
        : Scaffold(
        appBar: AppBar(
          actions: [
            CircleAvatar(
              backgroundImage:NetworkImage(restaurant!.pic!),
              backgroundColor: greenColor,
            ),
          ],
          title: const Text(
            'Accepted Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 5,
        ),
        drawer: MyShopkeeperDrawer(restaurant: restaurant!,),
        body: RefreshIndicator(

          onRefresh: () async { await fetchacceptedorder(); },
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: order!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10,),
            itemBuilder: (context, index) {
              return AcceptedOrderCard(data: order![index]);

            },
          ),
        ));
  }
}
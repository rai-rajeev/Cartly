import 'package:cartly/model/restInfo.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:cartly/widgets/my_shopkeeper_drawer.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/constants.dart';
import '../constant/loader.dart';
import '../model/orderInfo.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../widgets/shopkeeperOrderHistoryCard.dart';


class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Order>? orders;
  RestInfo? restaurant;
  final OrderServ restServ = OrderServ();
  fetchcompletedorder() async {
    orders = await restServ.fetchCompletedOrders(context);
    orders!.addAll(await restServ.fetchRejectedOrders(context));
    orders!.sort((a,b)=>DateTime.parse(a.timeOfOrder).compareTo(DateTime.parse(b.timeOfOrder)));
    final restid=await SharedPrefs().getRestId();
    restaurant=await RestaurantServ().fetchRestaurantsbyID(context, restid!);
    setState(() {});
  }


  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcompletedorder();
  }

  var status = "Ready?";
  var items = List<String>.generate(100, (i) => 'Item $i');
  var itemsList = List<List<String>>.generate(
      100, (i) => ['Item $i', 'Item ${(i + 1)}', 'Item ${(i + 2)}']);
  @override
  Widget build(BuildContext context) {
    //fetchcompletedorder();
    return orders == null
        ? const Loader()
        : RefreshIndicator(
          onRefresh:() async { await fetchcompletedorder();},
          child: Scaffold(
          appBar: AppBar(
            actions:[
              CircleAvatar(
                backgroundImage: NetworkImage(restaurant!.pic!),
                backgroundColor: greenColor,
              ),
            ],
            title: const Text(
              'Orders History ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            elevation: 5,
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: orders!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10,),
            itemBuilder: (context, index) {
              return CompletedOrderCard(data: orders![index]);

            },
          )),
        );
  }
}
import 'package:cartly/model/restInfo.dart';
import 'package:cartly/services/restaurantServ.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:flutter/material.dart';

import '../constant/loader.dart';
import '../model/orderInfo.dart';
import '../services/orderServ.dart';
import '../widgets/ShopkeeperOrderCard.dart';
import '../widgets/my_shopkeeper_drawer.dart';


class ShopkeeperOrdersScreen extends StatefulWidget {
  const ShopkeeperOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ShopkeeperOrdersScreen> createState() => _ShopkeeperOrdersScreenState();
}

class _ShopkeeperOrdersScreenState extends State<ShopkeeperOrdersScreen>
    with SingleTickerProviderStateMixin {
  List<Order>? order;
  final OrderServ restServ = OrderServ();
  RestInfo? restaurant;
  fetchresponsependingorder() async {
    order = await restServ.fetchResponsePendingOrders(context);
    final restid=await SharedPrefs().getRestId();
    restaurant=await RestaurantServ().fetchRestaurantsbyID(context, restid!);
    setState(() {});
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchresponsependingorder();
  }

  var items = List<String>.generate(100, (i) => 'Item $i');
  var itemsList = List<List<String>>.generate(
      100, (i) => ['Item $i', 'Item ${(i + 1)}', 'Item ${(i + 2)}']);
  @override
  Widget build(BuildContext context) {
    fetchresponsependingorder();
    return order == null
        ? const Loader()
        : Scaffold(
        appBar: AppBar(
          // backgroundColor: greenColor,
          actions:  [
            CircleAvatar(
              backgroundImage:NetworkImage(restaurant!.pic!),
              // backgroundColor: greenColor,
            ),
          ],
          title: const Text(
            'Current Orders',
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
        body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: order!.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  OrderCard(data: order![index]),
                  Container(
                    // alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(

                    ),
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () async {
                              // setState(() async {
                              await OrderServ()
                                  .AcceptOrders(context, order![index].id);

                                fetchresponsependingorder();


                            },
                            style: ElevatedButton.styleFrom(
                              // backgroundColor: Colors.green,
                            ),
                            icon: const Icon(Icons.check),
                            label: const Text('Accept')),
                        ElevatedButton.icon(
                            onPressed: () async {
                              await OrderServ()
                                  .RejectOrders(context, order![index]);
                              setState(() {
                                fetchresponsependingorder();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            icon: const Icon(Icons.close),
                            label: const Text('Reject')),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}

import 'dart:typed_data';
import 'dart:ui';

import 'package:cartly/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../constant/colors.dart';
import '../constant/loader.dart';

import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/DishfromDish_id.dart';
import '../services/listdishesTomap.dart';
import '../services/restaurantServ.dart';

class CompletedOrderCard extends StatefulWidget {
  // final RestaurantServ restServ = RestaurantServ();

  final Order data;
  const CompletedOrderCard({Key? key, required this.data}) : super(key: key);

  @override
  State<CompletedOrderCard> createState() => _CompletedOrderCardState();
}

List<String> abc(List<DishInfo?> dishes) {
  List<String> names = [];

  for (int i = 0; i < dishes.length; i++) {
    names.add(dishes[i]!.name!);
  }
  return names;
  // print("hello123");
}

class _CompletedOrderCardState extends State<CompletedOrderCard> {
  List<DishInfo>? dishes;
  fetchallorder() async {
    dishes = await RestaurantServ().fetchDish(context, widget.data.items);
    if (dishes != null) {
      abc(dishes!);
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchallorder();
    // abc();
    // _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    // List<int> bufferInt= widget.data.pic.map((e) => e as int).toList();
    final themeProvider=Provider.of<ThemeProvider>(context);
    var fav = false;
    return dishes == null
        ? const Loader()
        : Container(
        height: 114,
        decoration: BoxDecoration(
          // color: Colors.green[100],
            border: Border.all(
              color:themeProvider.isDarkMode?Colors.white: blackColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order ID: ${widget.data.id.substring(0, 3)}...${widget.data.id.substring(widget.data.id.length - 3, widget.data.id.length)}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Time: ${widget.data.timeOfOrder.substring(11, 16)}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(children: [
              Expanded(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    // ignore: unnecessary_null_comparison
                    child: abc(dishes!) != null
                        ? Text(
                      'Order Items: ${abc(dishes!)}'
                          .replaceAll('[', '')
                          .replaceAll(']', ''),
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )
                        : const SizedBox(
                      height: 0,
                      width: 0,
                    )),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // alignment: Alignment.bottomRight,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.all(9),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: widget.data.orderStatus=='completed'?Colors.lightGreen:Colors.redAccent
                  ),
                  child: Text(widget.data.orderStatus.toUpperCase()),
                ),
                Builder(
                  builder: ((context) {
                    return TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          // backgroundColor: Colors.green.shade100,
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                body: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(
                                          Icons.pending_actions_sharp),
                                      title: Text(
                                        (widget.data.orderStatus=='completed')?'Order is completed.':'Order is rejected',
                                        style: TextStyle(
                                            color: Colors.red.shade300),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.note),
                                      title:
                                      Text('Order ID: ${widget.data.id}'),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.calendar_month_outlined),
                                      title: Text(
                                          'Date: ${widget.data.timeOfOrder.substring(0, 10)}'),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.lock_clock),
                                      title: Text(
                                          'Time: ${widget.data.timeOfOrder.substring(11, 16)}'),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.money),
                                      title: Text(
                                          'Total Price: ${widget.data.total}'),
                                    ),
                                    ListTile(
                                      isThreeLine: true,
                                      leading: const Icon(Icons.list_sharp),
                                      title: const Text('Order Items: '),
                                      subtitle: Text(
                                        '${convert().listToMap(abc(dishes!))}'
                                            .replaceAll('{', '')
                                            .replaceAll('}', ''),
                                        style:
                                        const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Text('See More'),

                    );
                  }),
                ),
              ],
            ),

          ],
        )

    );
  }
}
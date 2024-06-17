import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/colors.dart';
import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/restaurantServ.dart';
import '../theme_provider.dart';

class AcceptedOrderCard extends StatefulWidget {
  // final RestaurantServ restServ = RestaurantServ();

  final Order data;
  const AcceptedOrderCard({Key? key, required this.data}) : super(key: key);

  @override
  State<AcceptedOrderCard> createState() => _AcceptedOrderCardState();
}

List<String> abc(List<DishInfo?> dishes) {
  List<String> names = [];

  for (int i = 0; i < dishes.length; i++) {
    // print(dishes![i].name!);
    // print(dishes[i]!.name!);
    names.add(dishes[i]!.name!);
  }
  return names;
  // print("hello123");
}

class _AcceptedOrderCardState extends State<AcceptedOrderCard> {
  List<DishInfo>? dishes;
  fetchallorder() async {
    dishes = await RestaurantServ().fetchDish(context, widget.data.items);
    if (dishes != null) {
      abc(dishes!);
    }
    setState(() {});
  }


  void initState() {
    // TODO: implement initState
    super.initState();
    fetchallorder();
    // abc();
    // _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider=Provider.of<ThemeProvider>(context);
    // List<int> bufferInt= widget.data.pic.map((e) => e as int).toList();
    var fav = false;
    return dishes == null
        ? const Loader()
        : Container(
        height: 114,
        decoration: BoxDecoration(
          // color: Colors.green[100],
            border: Border.all(
              color: themeProvider.isDarkMode?Colors.white:blackColor,
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
                      'Order Items: ${convert().listToMap(abc(dishes!))}'
                          .replaceAll('{', '')
                          .replaceAll('}', ''),
                      style: const TextStyle(fontSize: 20),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    )
                        : Container(
                      height: 0,
                      width: 0,
                    )),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Builder(
                  builder: ((context) {
                    return TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.pending_actions_sharp),
                                    title: Text(
                                      'Order is not yet delivered',
                                      style: TextStyle(
                                          color: Colors.red.shade300),
                                    ),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.note),
                                    title:
                                    Text('Order ID: ${widget.data.id}'),
                                  ),
                                  // ignore: prefer_const_constructors
                                  ListTile(
                                    leading: const Icon(Icons.lock_clock),
                                    // ignore: prefer_const_constructors
                                    title: Text(
                                        'Time: ${widget.data.timeOfOrder.substring(11, 16)}'),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.money),
                                    title: Text(
                                        'Total Price: Rupees: ${widget.data.total}'),
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
                              );
                            });
                      },
                      child: const Text('See More'),
                    );
                  }),
                ),
              ],
            ),
            // TextButton(
            //     onPressed: () {}, child: Text('See More'))),
          ],
        )
    );
  }
}
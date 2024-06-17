import 'dart:ui';
import 'package:cartly/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/colors.dart';
import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/restaurantServ.dart';


class OrderCard extends StatefulWidget {
  // final RestaurantServ restServ = RestaurantServ();

  final Order data;
  const OrderCard({Key? key, required this.data}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
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

class _OrderCardState extends State<OrderCard> {
  List<DishInfo>? dishes;
  void fetchallorder() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider=Provider.of<ThemeProvider>(context);
    var map = convert().listToMap(abc(dishes!));
    return dishes == null
        ? const Loader()
        : Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
            height: 115,
            decoration: BoxDecoration(
              // color: Colors.green[100],
                border: Border.all(
                  color:themeProvider.isDarkMode?Colors.white: blackColor,
                ),
                borderRadius:
                const BorderRadius.all(Radius.circular(20))),
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
                          overflow: TextOverflow.ellipsis,
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
                      child: dishes != null
                          ? Text(
                        'Order Items: ${map}'
                            .replaceAll('{', '')
                            .replaceAll('}', ''),
                        style: const TextStyle(fontSize: 20),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      )
                          : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    ),
                  ),
                ]),
                Row(
                  // alignment: Alignment.topRight,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Builder(
                        builder: ((context) {
                          return TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  // backgroundColor:
                                  //     Colors.green.shade100,
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          ListTile(
                                            leading:
                                            const Icon(Icons.note),
                                            title: Text(
                                                'Order ID: ${widget.data.id}'),
                                          ),
                                          // ignore: prefer_const_constructors
                                          ListTile(
                                            leading: const Icon(
                                                Icons.lock_clock),
                                            // ignore: prefer_const_constructors
                                            title: Text(
                                                'Time: ${widget.data.timeOfOrder.substring(11, 16)}'),
                                          ),
                                          ListTile(
                                            leading:
                                            const Icon(Icons.money),
                                            title: Text(
                                                'Total Price: Rupees: ${widget.data.total}'),
                                          ),
                                          Flexible(
                                            child: ListTile(
                                              isThreeLine: true,
                                              leading: const Icon(
                                                  Icons.list_sharp),
                                              title: const Text(
                                                  'Order Items: '),
                                              subtitle: Text(
                                                '${convert().listToMap(abc(dishes!))}'
                                                    .replaceAll('{', '')
                                                    .replaceAll('}', ''),
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),

                                        ],
                                      );
                                    });
                              },
                              child: const Text('See More'));
                        }),
                      ),
                    ]),
                // TextButton(
                //     onPressed: () {}, child: Text('See More'))),
              ],
            )
          //Text("\tOrder ID: ${items[index]}"),
        ),

      ],
    );
  }
}
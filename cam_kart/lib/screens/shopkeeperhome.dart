import 'package:flutter/material.dart';
import '../constant/constants.dart';
import '../constant/loading.dart';
import '../model/dishInfo.dart';
import '../model/restInfo.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../services/shared_prefs.dart';
import '../widgets/my_shopkeeper_drawer.dart';

class ShopkeeperHomePage extends StatefulWidget {
  const ShopkeeperHomePage({Key? key}) : super(key: key);

  @override
  State<ShopkeeperHomePage> createState() => _ShopkeeperHomePageState();
}

class _ShopkeeperHomePageState extends State<ShopkeeperHomePage> {
  var textEditingController = TextEditingController();
  int index = 0;

  bool isLoading = true;
  String restId = '';
  RestInfo? restaurant;

  List<bool> isSelected = [true, false];

  List<DishInfo> menu = [];
  String restName = '';
  Future<void> changeStatus(String changedTo) async {
    await RestaurantServ().changeStatus(context, restId, changedTo);
  }

  Future<List<DishInfo>> getData() async {
    List<DishInfo> menulocal = [];
    restId = (await SharedPrefs().getRestId())!;
    //final tkn = '';
    List<DishInfo>? result = await RestaurantServ().fetchMenu(context, restId);

    restaurant = await RestaurantServ().fetchRestaurantsbyID(context, restId);
    menulocal = result ?? [];
    if (mounted) {
      setState(() {
        menu = menulocal;
        restName = restaurant!.restaurantName;
        isSelected = [restaurant!.status == 'on', restaurant!.status == 'off'];
        isLoading = false;
      });
    }
    return menu;
  }

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                restName,
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    child: SearchBar(
                      controller: searchController,
                      hintText: 'Search items Here !',
                      onChanged: (e) {
                        setState(() {});
                      },
                    )),
              ),
            ),
            drawer: MyShopkeeperDrawer(
              restaurant: restaurant!,
            ),
            body: RefreshIndicator(
              onRefresh: getData,
              child: Column(children: <Widget>[
                const SizedBox(height: 10),
                Expanded(
                    child: ListView.separated(
                        itemCount: menu.length,
                        itemBuilder: (context, index) {
                          return (searchController.text.trim() == '' ||
                                  menu[index]
                                      .name!.toLowerCase()
                                      .contains(searchController.text.trim().toLowerCase()) ||
                                  menu[index]
                                      .price
                                      .toString().toLowerCase()
                                      .contains(searchController.text.trim().toLowerCase()))
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Container(
                                              height: 120,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.transparent),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      menu[index].pic!),
                                                  // colorFilter: (menu[index].status=='on') ? null:new ColorFilter.mode(Colors.grey, BlendMode.saturation),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: const BorderSide(
                                                        color: Colors.white)),
                                                color: (menu[index].inStock
                                                    ? Colors.green
                                                    : Colors.red),
                                                child: InkWell(
                                                    onTap: () async {
                                                      await (OrderServ()
                                                          .InOutStock(context,
                                                              menu[index]));
                                                      setState(() {});
                                                    },
                                                    child: (menu[index].inStock
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Text(
                                                              "In stock",
                                                              style: TextStyle(
                                                                  //fontSize: 15,
                                                                  // color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          )
                                                        : const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "Out of stock",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  // color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ))))
                                          ]),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.crop_square_sharp,
                                                        color: (menu[index]
                                                                    .category ==
                                                                'veg')
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: 18,
                                                      ),
                                                      Icon(Icons.circle,
                                                          color: (menu[index]
                                                                      .category ==
                                                                  'veg')
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 9),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 244, 100, 56),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  6)),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 2.0,
                                                          horizontal: 6.0),
                                                      child: Text(
                                                        menu[index]
                                                                .suggestedTime ??
                                                            'null',
                                                        style: const TextStyle(
                                                            // color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: Text(
                                              menu[index].name!,
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Text(
                                                  '₹${menu[index].price}',
                                                  style: const TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await OrderServ().RemoveItem(
                                                      context, menu[index].id,restaurant!);
                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons.delete),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                );
                        }, separatorBuilder: (BuildContext context, int index)  =>div,))
              ]),
            ),
          );
  }
}

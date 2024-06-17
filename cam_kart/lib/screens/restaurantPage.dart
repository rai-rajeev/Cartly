
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cartly/constant/loading.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/dishInfo.dart';
import '../model/orders.dart';
import '../model/restInfo.dart';
import '../services/restaurantServ.dart';
import '../widgets/buttons1.dart';
import 'cart.dart';
import 'package:geocoding/geocoding.dart';



class RestaurantPage extends StatefulWidget {
  final String data;
  final String image;
  const RestaurantPage({Key? key, required this.data, required this.image}) : super(key: key);
  @override
  State<StatefulWidget> createState() => RestaurantPageState();
}

class RestaurantPageState extends State<RestaurantPage> with SingleTickerProviderStateMixin {

  List<DishInfo> dishes = [];
  late Orders cartforres;
  late RestInfo restaurant;
  late Map<String,int> dishesadded;

  bool isLoading = true;

  final RestaurantServ restServ = RestaurantServ();
  Future<void> fetchrestaurantbyID() async{
    RestInfo restlocal=await restServ.fetchRestaurantsbyID(context, widget.data);

    setState(() {
      restaurant=restlocal;
      isLoading = false;
    });

    await fetchalldish();
    Map<String,int> initial =await restServ.itemsInCartFromRes(restaurant, context);
    debugPrint('$initial');
    count=List<int>.filled(dishes.length,0);
    isadd=List<bool>.filled(dishes.length, true);
    for(int i=0;i<dishes.length;i++){
      if(initial.containsKey(dishes[i].id)){
        count[i]=initial[dishes[i].id]!;
        isadd[i]=false;
        itemc+=count[i];
        sum+=count[i]*dishes[i].price!;
      }
    }
    await fetchlocation(restaurant.location);


    setState(() {

    });
    if(itemc!=0){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller?.forward();
      });

    }
  }
  fetchlocation(String coordinate) async {
    var latlng= coordinate.split(',');
    debugPrint('$latlng');
    var coordi=[double.parse(latlng[0]),double.parse(latlng[1])];
    debugPrint('$coordi');
    List<Placemark> placemarks = await placemarkFromCoordinates(coordi[0],coordi[1]);
    debugPrint('$coordi');
    location=placemarks[0].subLocality!+', '+ placemarks[0].administrativeArea!+', '+placemarks[0].country!+"-"+placemarks[0].postalCode!;
  }
  fetchalldish() async {
    final disheslocal = await restServ.fetchDish(context, restaurant.menu);
    print('fetchedall');
    print(dishes);
    setState(() {
      dishes = disheslocal;
    });
  }
  postcartdish(DishInfo dish) async {
    await restServ.postCartOrder(context, dish);
    setState(() {
    });
  }
  removecartdish(DishInfo dish) async {
    await restServ.removeCartOrder(context, dish);
    setState(() {
    });
  }
  final List<bool> isel = [false, false, false, false, false, false];
  String dropdownvalue = 'Below ₹1000';

  List<int> count = [1, 1, 1, 1, 1];
  int itemc = 0;

  String location='';
  int sum = 0;
   List<bool> isadd = [
    true,
    true,
    true,
    true,
    true,
  ];
  AnimationController? controller;
  Animation<Offset>? offset;

  @override
  void initState()  {
    super.initState();
    fetchrestaurantbyID();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    offset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller!);
  }


  @override
  Widget build(BuildContext context) {
    return  isLoading ? const Loading():
      Scaffold(

        body: RefreshIndicator(
          onRefresh: () async{await fetchrestaurantbyID();},
          child: Stack(children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    Image(
                      image: NetworkImage(widget.image),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.greenAccent,
                          size: 35,
                        )),
                    Positioned(
                        left: 10,
                        bottom: 25,
                        child: BlurryContainer(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          blur: 0,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurant.restaurantName,
                              style: const TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                        )),
                    Positioned(
                        left: 10,
                        bottom: 7,
                        child: BlurryContainer(
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          blur: 0,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              location,
                              style: const TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        )),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new_button1(
                        text: "TIMING", ic: Icons.access_time_outlined,
                        onTap: () {
                          Widget okbutton = TextButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const Text("OK",style: TextStyle(fontSize: 20),));
                          AlertDialog alert = AlertDialog(
                            title: const Text("Timing"),
                            content:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Opens at: ${restaurant.openingTime}",style: const TextStyle(fontSize: 20),),
                                ),
                                 Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text("Closes at: ${restaurant.closingTime}",style: const TextStyle(fontSize: 20),),
                                ),
                              ],
                            ),
                            actions: [
                              okbutton,
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (context) => alert,
                            barrierDismissible: true,
                          );
                        },
                      ),
                      Container(
                        child: new_button1(
                          text: "LOCATION", ic: Icons.location_on,
                          onTap: () async{
                            Uri map = Uri.parse('https://www.google.com/maps/search/?api=1&query=${restaurant.location}');
                            if (await launchUrl(map)) {
                            }else{
                              print("error calling map");
                            }
                          },
                        ),
                      ),
                      Container(
                        child: new_button1(text: "CONTACT", ic: Icons.phone,onTap: () async{
                          Uri phoneno = Uri.parse('tel:${restaurant.phoneNumber}');
                          if (await launchUrl(phoneno)) {
                          }else{
                            print("error calling log");
                          }
                        },),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                AbsorbPointer(
                  absorbing: (restaurant.status=='on')?false:true,
                  child: SizedBox(
                    height: (9+161.8*5+150),
                    child: ListView.builder(
                      itemCount: dishes.length,
                      itemBuilder: (context, index) => AbsorbPointer(
                        absorbing: (dishes[index].inStock)?false:true,
                        child: ColorFiltered(
                          colorFilter: (dishes[index].inStock) ? const ColorFilter.mode(Colors.white, BlendMode.modulate):const ColorFilter.mode(Color(0xFFE0E0E0), BlendMode.saturation),
                          child: Column(
                            children: [

                              const Divider(
                                thickness: 2,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 12),
                                              child: Wrap(
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Icon(
                                                          Icons.crop_square_sharp,
                                                          color: (dishes[index].category == 'veg')
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 18,
                                                        ),
                                                        Icon(Icons.circle,
                                                            color: (dishes[index].category == 'veg')
                                                                ? Colors.green
                                                                : Colors.red,
                                                            size: 7),
                                                      ],
                                                    ),

                                                  ]),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 10),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 244, 100, 56),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(6)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 2.0, horizontal: 6.0),
                                                  child: Text(
                                                    dishes[index].suggestedTime.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 12, bottom: 8),
                                        child: Text(
                                          dishes[index].name!,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 12, right: 12),
                                        child: Text(
                                          "₹${dishes[index].price}",
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only( top: 8,right: 16),
                                    child: Stack(children: [
                                      Container(
                                        height: 140,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: SizedBox(
                                          height: 120,
                                          width: 120,
                                          child: Image(
                                            image: NetworkImage(dishes[index].pic!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          left: (isadd[index] ? 16.5 : 12),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    isadd[index] ? 10 : 20),
                                                side: const BorderSide(color: Colors.red)),
                                            color: const Color.fromARGB(255, 250, 235, 233),
                                            child: (isadd[index]
                                                ? InkWell(
                                              onTap: () {
                                                isadd[index] = false;
                                                itemc++;
                                                sum+=dishes[index].price!;
                                                count[index]++;
                                                if(itemc==1){
                                                  controller!.forward();
                                                }
                                                postcartdish(dishes[index]);
                                                setState(() {});
                                              },
                                              child: const Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        left: 20,
                                                        right: 6,
                                                        top: 7,
                                                        bottom: 7),
                                                    child: Text(
                                                      "ADD",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        top: 3, right: 6),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.red,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : Row(
                                              children: [
                                                IconButton(
                                                    constraints:
                                                    const BoxConstraints(),
                                                    onPressed: () {
                                                      if(count[index]>0){
                                                        count[index]--;
                                                        itemc--;
                                                        sum-=dishes[index].price!;
                                                        if(itemc==0){
                                                          controller!.reverse();
                                                        }
                                                        if(count[index]==0){
                                                          count[index]=1;
                                                          isadd[index]= true;
                                                        }
                                                        removecartdish(dishes[index]);
                                                        setState(
                                                              () {},
                                                        );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.remove,
                                                    )),
                                                Text("${count[index]}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.w700)),
                                                IconButton(
                                                    onPressed: () {
                                                      count[index]++;
                                                      itemc++;
                                                      sum+=dishes[index].price!;
                                                      postcartdish(dishes[index]);
                                                      setState(() {

                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.add,
                                                    ),
                                                    constraints:
                                                    const BoxConstraints()),
                                              ],
                                            )),
                                          ))
                                    ]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: offset!,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 60, top: 8, left: 8, right: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$itemc item(s) in cart",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "₹$sum",
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const cart()));
                    },
                  ),
                ),
              ),
            )
          ]),
        ),

    );
  }
}

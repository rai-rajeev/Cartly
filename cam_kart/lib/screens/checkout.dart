import 'package:cartly/screens/restHome.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constant/loading.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../model/restInfo.dart';
import '../services/listdishesTomap.dart';
import '../services/orderServ.dart';
import '../services/restaurantServ.dart';
import '../theme_provider.dart';
import '../widgets/menuCard.dart';


class checkout extends StatefulWidget {
  // final String orderID;
  final Order order;
  final String name;
  const checkout({Key? key, required this.order,required this.name}) : super(key: key);

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {

  Order? refOrder;
  Map<String, int> dishes = {};
  Map<DishInfo, int> fetchedDishes = {};
  RestInfo? rest;
  fetchorder() async {
    refOrder = await OrderServ().fetchOrderbyId(context, widget.order.id);
    rest=await RestaurantServ().fetchRestaurantsbyID(context, refOrder!.restaurantId);
    fetchmenu();
    // setState(() {
    //
    // });
  }
  fetchmenu() async{
    dishes=convert().listToMap(refOrder!.items);
    List<String> dishIdsOrder=[];
    for(String key in dishes.keys.toList()){
      dishIdsOrder.add(key);
    }
    List<DishInfo> x = await RestaurantServ().fetchDish(context, dishIdsOrder);
    Map<DishInfo, int> mp = {};
    for (int j = 0; j < x.length; j++) {
      mp[x[j]] = dishes[x[j].id]!;
    }
    fetchedDishes = (mp);
    setState(() {});
  }
  postcartdish(DishInfo dish) async {
    await RestaurantServ().postCartOrder(context, dish);
    setState(() {

    });
  }
  removecartdish(DishInfo dish) async {
    await RestaurantServ().removeCartOrder(context, dish);
    setState(() {

    });
  }
  final Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    fetchorder();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> openCheckout() async {

    final info=await OrderServ().checkout(context, refOrder!);
    debugPrint('$info');
    if(info['status']=='success') {
      var options = {
        'key': 'rzp_test_MX8O2IEwO17yuI',
        'order_id':info['orderId'],
        'prefill': {
          'contact': rest!.phoneNumber,
          'email': rest!.email,
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      // Map<String,String> mp= (options==null)? {}: mp;
      print(options);
      print('skfhskjhs');


      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {

    try {

      print(response.toString());
      print(response.runtimeType);
      print(response.signature.toString());
      print(response.orderId.toString());
      await OrderServ().acknowledge(context, refOrder!.id,response.paymentId!);
      Fluttertoast.showToast(
        msg: "SUCCESS: ${response.paymentId}",
        timeInSecForIosWeb: 4,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
    catch(e)
    {
      print(e);
    }


  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: ${response.code} - ${response.message}",
      timeInSecForIosWeb: 4,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: ${response.walletName}",
      timeInSecForIosWeb: 4,
    );
  }

  final List<int> count = [1, 1, 1, 1, 1];
  var itemc = 0;
  final List<int> price = [100, 200, 300, 400, 500];
  var sum = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    //final themeProvider = Provider.of<ThemeProvider>(context);

    fetchorder();
    return (refOrder==null)?const Loading():Scaffold(
      appBar: AppBar(
        title: const Text('CheckOut',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
         // backgroundColor: const Color(0xff307A59),
        centerTitle: true,
        elevation: 4,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
            // decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Text((widget.name),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              itemBuilder: (context, index) {
                DishInfo key=fetchedDishes.keys.elementAt(index);
                int value=fetchedDishes.values.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuCard(dish: key,freq: value),
                          Column(

                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(width: 0.2,color: Colors.red),
                                  borderRadius: BorderRadius.circular(28.0),
                                  // color: Colors.red[50]

                                ),
                                child: Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      removecartdish(fetchedDishes.keys.elementAt(index));
                                    },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 15,
                                      ),
                                      style: ButtonStyle( backgroundColor: MaterialStatePropertyAll<Color>(themeProvider.isDarkMode?Colors.white12:Colors.black12),),),


                                    Text(value.toString(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                    // Container(width: 2,color: Colors.black,),
                                    // SizedBox(width: 2,child: Container(color: Colors.red,),),
                                    IconButton(onPressed: (){
                                      postcartdish(fetchedDishes.keys.elementAt(index));
                                      fetchorder();
                                    },
                                      icon: const Icon(
                                        Icons.add,
                                        size: 15,
                                      ),
                                      style: ButtonStyle( backgroundColor: MaterialStatePropertyAll<Color>(themeProvider.isDarkMode?Colors.white12:Colors.black12),),

                                    ),

                                  ],
                                ),
                              ),
                              // SizedBox(height: 5,),
                              Text('₹${value*(fetchedDishes.keys.elementAt(index).price!)}' , style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)
                              //
                            ],
                          ),


                        ],
                      ),

                    ],
                  ),
                ); //(data: widget.stat[index]
              },
              shrinkWrap: true,
              //scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 1,
                );
              },
              itemCount: fetchedDishes.length),
          const Divider(),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${refOrder!.total.toString()}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 20),
            child: GestureDetector(
                onTap: ()
                async {
                  debugPrint('proceeding');
                  await openCheckout();

                },
                child:Container(

                  height: 50,
                  decoration: BoxDecoration(color:  Colors.pink,borderRadius: BorderRadius.circular(60)),
                  child: Center(child: Text('BUY NOW : ₹${refOrder!.total.toString()}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),)),
                )

            ),
          ),
        ],
        //physics: BouncingScrollPhysics(),
      ),

      // bottomNavigationBar:


    );
  }
}
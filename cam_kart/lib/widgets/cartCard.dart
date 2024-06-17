import 'dart:ui';

import 'package:flutter/material.dart';


import 'package:expandable/expandable.dart';
import 'package:geocoding/geocoding.dart';

import '../constant/loader.dart';
import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../model/restInfo.dart';
import '../screens/checkout.dart';
import '../services/DishfromDish_id.dart';

class CartCard extends StatefulWidget {
  final Order orders;
  final Map<DishInfo,int> mp;
  const CartCard({Key? key, required this.orders,required this.mp}) : super(key: key);
  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  RestInfo? rest;
  fetchrest() async{
    RestInfo restlocal=await restServ.fetchRestaurantsbyID(context, widget.orders.restaurantId);
    await fetchlocation(restlocal.location);
    setState(() {
      rest=restlocal;
    });
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
  String location='Loading...';
  @override
  void initState(){
    super.initState();
    fetchrest();


  }
  @override
  Widget build(BuildContext context) {
    return (rest==null)?const Loader():Card(
      color: Theme.of(context).primaryColorLight,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        elevation: 10.0,
        // shadowColor: Colors.grey,
        //shape: ShapeBorder(BorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rest!.restaurantName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),   //widget.data.restaurantName
                              Text(location,style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),overflow: TextOverflow.clip,)     //widget.data.category
                            ],
                          ),

                        ],
                      ),

                      GestureDetector(
                        onTap: ()
                        {
                          print("Container clicked");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) => checkout(order: widget.orders,name: rest!.restaurantName)));

                        },
                        //behavior: ,
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.pink),child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Checkout',style: TextStyle(fontWeight: FontWeight.w300 )),  //(( widget.data.status== 'accepted')?'Accepted':'Rejected')
                        ),),//(( widget.data.status== 'accepted')?Colors.greemAccent:Colors.orange)
                      )
                    ],
                  ),  //rest.name


                  Container(height: 1,color: Colors.black,),
                  ExpandablePanel(
                    header: const Text('View All'),
                    collapsed: ListView.separated(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (context, index) {
                          DishInfo key=widget.mp.keys.elementAt(index);
                          int value=widget.mp.values.elementAt(index);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(key.name!,style: const TextStyle(fontSize: 15),),                 //widget.data.dish[i].name
                              Text('${value} x ₹${key.price}',style: const TextStyle(fontSize: 15),)                 //item count x item price
                            ],
                          ); //(data: widget.stat[index]
                        },
                        shrinkWrap: true,
                        //scrollDirection: Axis.vertical,
                        // physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 1,
                          );
                        },
                        itemCount: 1
                    ),
                    expanded: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        DishInfo key=widget.mp.keys.elementAt(index);
                        int value=widget.mp.values.elementAt(index);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(key.name!,style: const TextStyle(fontSize: 15),),
                            Text('$value x ₹${key.price}',style: const TextStyle(fontSize: 15),)                 //item count x item price
                          ],
                        ); //(data: widget.stat[index]
                      },
                      shrinkWrap: true,
                      //scrollDirection: Axis.vertical,
                      // physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 1,
                        );
                      },
                      itemCount: widget.mp.length,
                    ),

                    //tapHeaderToExpand: true,
                    //hasIcon: true,
                  ),

                  // Container(height: 80,
                  // child: ),

                  Container(height: 1, color: Colors.black,),
                  Container(height: 1,color: Colors.black,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Text('15/02/2023 at 9:53 p.m.',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                      Text('₹${widget.orders.total.toString()}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold))                                                     //total amount
                    ],
                  ),
                  //Container(height: 1,color: Colors.black,)


                ],
              ),
            ),
          ]),
        ));
  }
}

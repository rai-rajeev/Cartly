import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:expandable/expandable.dart';
import 'package:geocoding/geocoding.dart';

import '../constant/loader.dart';

import '../model/dishInfo.dart';
import '../model/orderInfo.dart';
import '../model/restInfo.dart';
import '../services/DishfromDish_id.dart';

class HistCard extends StatefulWidget {
  final Order orders;
  final Map<DishInfo,int> mp;
  const HistCard({Key? key, required this.orders,required this.mp}) : super(key: key);
  @override
  State<HistCard> createState() => _HistCardState();
}

class _HistCardState extends State<HistCard> {
  RestInfo? rest;
  fetchlocation(String coordinate) async {
    var latlng= coordinate.split(',');
    debugPrint('$latlng');
    var coordi=[double.parse(latlng[0]),double.parse(latlng[1])];
    debugPrint('$coordi');
    List<Placemark> placemarks = await placemarkFromCoordinates(coordi[0],coordi[1]);
    debugPrint('$coordi');
    location=placemarks[0].subLocality!+', '+placemarks[0].administrativeArea!+', '+placemarks[0].country!+"-"+placemarks[0].postalCode!;

  }
  fetchrest() async{
    RestInfo restlocal=await restServ.fetchRestaurantsbyID(context, widget.orders.restaurantId);
    rest=restlocal;
    await fetchlocation(rest!.location);
    setState(() {

    });
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        elevation: 10.0,
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
                          Image(
                            height: 80,
                            width: 90,
                            image:
                            NetworkImage(rest!.pic!),                                                //widget.data.dish[1].pic
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(rest!.restaurantName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),   //widget.data.restaurantName
                              Text(location,style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 15),overflow: TextOverflow.ellipsis,)     //widget.data.category
                            ],
                          ),
                          const SizedBox(width: 2,),
                          Container(
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:!(widget.orders.orderStatus=='rejected')? Colors.lightGreen:Colors.redAccent
                            ),
                            child:(widget.orders.orderStatus=='completed')? const Icon(Icons.done_all_rounded):const Icon(Icons.cancel_outlined),
                          )

                        ],
                      ),
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
                              Text('$value x ₹${key.price}',style: const TextStyle(fontSize: 15),)                 //item count x item price
                            ],
                          ); //(data: widget.stat[index]
                        },
                        shrinkWrap: true,
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
                        itemCount: widget.mp.length
                    ),

                  ),

                  // Container(height: 80,
                  // child: ),

                  Container(height: 1, color: Colors.black,),
                  Container(height: 1,color: Colors.black,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.orders.timeOfOrder.substring(0,10),style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
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

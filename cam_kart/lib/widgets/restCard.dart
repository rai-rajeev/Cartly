import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../model/restInfo.dart';
import '../screens/restaurantPage.dart';

class RestCard extends StatefulWidget {
  final RestInfo data;
  const RestCard({Key? key, required this.data}) : super(key: key);

  @override
  State<RestCard> createState() => _RestCardState();
}

class _RestCardState extends State<RestCard> {
  fetchlocation(String coordinate) async {
    var latlng= coordinate.split(',');
    debugPrint('$latlng');
    var coordi=[double.parse(latlng[0]),double.parse(latlng[1])];
    debugPrint('$coordi');
    List<Placemark> placemarks = await placemarkFromCoordinates(coordi[0],coordi[1]);
    debugPrint('$coordi');
    location=placemarks[0].subLocality!+', '+placemarks[0].administrativeArea!+', '+placemarks[0].country!+"-"+placemarks[0].postalCode!;
    setState(() {

    });
  }
  String location='loading....';
  @override
  void initState(){
    super.initState();
    fetchlocation(widget.data.location);


  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (widget.data.status=='on')?
        Navigator.push(context, MaterialPageRoute(builder: (context)=> RestaurantPage(data: widget.data.id,image: widget.data.pic!,)) ): null;
      },
      child:

      Container(
        width: 220,
        height: 180,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(widget.data.pic!),
            colorFilter: (widget.data.status=='on') ? null:const ColorFilter.mode(Colors.grey, BlendMode.saturation),
            fit: BoxFit.fill,
          ),
          border: Border.all(width: 0.9)
        ),
        // Recipe Card Info
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    widget.data.restaurantName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 150 / 100, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                  ),
                  // Recipe Calories and Time
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.location_pin, size: 12, color: Colors.white),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Text(
                                  location,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),]
                        ),
                        //SizedBox(width: 10),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.white),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                widget.data.phoneNumber,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
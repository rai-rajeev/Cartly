import 'dart:async';
import 'package:cartly/auth.dart';
import 'package:cartly/constant/text.dart';
import 'package:cartly/widgets/buttons1.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});
  @override
  State<LocationPicker> createState() => LocationPickerState();
}

class LocationPickerState extends State<LocationPicker> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng _currentPosition = const LatLng(37.42796133580664, -122.085749655962);
  bool done = false;
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
     await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(context, 'please provide it as it is required');
        permission = await Geolocator.requestPermission();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Permission is denied forever'),
                content: const Text(
                    'Open app setting and provide permission  to continue '),
                actions: [
                  new_button1(
                    text: 'Open Setting',
                    ic: Icons.settings,
                    onTap: () async {
                      await Geolocator.openAppSettings();
                    },
                  )
                ],
              ));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    done = true;
    setState(() {});
  }

  void _onCameraMove(CameraPosition positon) {
    _currentPosition = positon.target;
    setState(() {});
  }

  Future<void> _onTap(LatLng? position) async {
    _currentPosition = position ?? _currentPosition;
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 20,tilt: 60)));
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
   _goToCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: _currentPosition, zoom: 15),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {Marker(markerId:MarkerId('$_currentPosition'),position: _currentPosition)},
          onCameraMove: _onCameraMove,
          onTap: _onTap,
        ),
         Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 40,left: 18,right: 18),
            padding: const EdgeInsets.all(15),
            decoration:  BoxDecoration(
            color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(35)

            ),
            child: modified_text(
              text: 'Choose (${_currentPosition.latitude.toStringAsFixed(4)}, ${_currentPosition.longitude.toStringAsFixed(4)}) as  coordinates for your shop',
              size: 18,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.my_location,size:55,color: Colors.black,),
              onPressed: _goToCurrentPosition,
            ),
          ),

        ),
        Align(alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context,_currentPosition);
          },
            style: ElevatedButton.styleFrom(

            ),
            child:const modified_text(text: 'Select',size: 25,),),
        ),)
      ]),
    );
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    await _determinePosition();
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 20,tilt: 60)));

  }
}

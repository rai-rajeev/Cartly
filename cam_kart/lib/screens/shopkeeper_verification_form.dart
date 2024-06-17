import 'dart:io';

import 'package:cartly/services/location_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';
import '../constant/loading.dart';
import '../model/my_user.dart';
import '../model/shop_info.dart';
import '../services/google_auth.dart';
import '../services/restaurantServ.dart';
import '../services/shared_prefs.dart';

class ShopkeeperVerificationForm extends StatefulWidget {
  const ShopkeeperVerificationForm({super.key});

  @override
  State<ShopkeeperVerificationForm> createState() =>
      _ShopkeeperVerificationFormState();
}

class _ShopkeeperVerificationFormState
    extends State<ShopkeeperVerificationForm> {
  bool isLoading = false;
  bool hide =true;

  String keyId = '';
  String keySecret = '';

  String? shopType='Eatery';
  String shopName = '';
  String location = '';
  String startingTime = '';
  String closingTime = '';

  final _formKey = GlobalKey<FormState>();
  final startTimeController = TextEditingController();
  final closeTimeController = TextEditingController();
  final locationController=TextEditingController();
  File? _image;
  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      this._image = imageTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    void showToast(String message) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 16),
          ),
        ),
      );
    }

    final user = Provider.of<MyUser?>(context);

    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      await GoogleAuthentication().googleLogout();
                    },
                    icon: const Icon(Icons.logout))
              ],
              elevation: 1,
              title: const Text('Cartly',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
              centerTitle: true,
            ),
            bottomNavigationBar: NavigationBar(
              elevation: 1,
              height: 65,
              destinations: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (shopType == null) {
                            showToast('Please fill all the fields');
                          } else if (startingTime == '' || closingTime == '') {
                            showToast('Fields cannot be left empty');
                          }
                          else if (location==''){
                            showToast('Fields cannot be left empty');
                          }
                          else {
                            setState(() {
                              isLoading = true;
                            });
                            if (shopType == 'Eatery') {
                              try {
                                final phone =await SharedPrefs().getPhone();
                                final data = ShopVerificationInfo(
                                    closeTime: closingTime,
                                    shopName: shopName,
                                    shopType: shopType!,
                                    startTime: startingTime,
                                    location: location,
                                    phoneNumber:phone! ,
                                    keyId: keyId,
                                    secretKey: keySecret);
                                RestaurantServ()
                                    .postRestaurant(data, user, _image);
                              } catch (e) {
                                print(e.toString());
                              }

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('isVeriFormSubmitted', true);
                              await prefs.setString('shopType', 'Eatery');

                             // final tkn = await SharedPrefs().getToken();
                            }
                          }
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 2),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //height: 250,
                            child: (_image != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Center(child: Image.file(_image!)),
                                  )
                                : null),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Text(
                              'Shop Details',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              validator: (value) =>
                                  value == '' ? 'Field cannot be empty' : null,
                              onChanged: (value) {
                                setState(() {
                                  shopName = value;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Shop Name',
                                  prefixIcon: const Icon(Icons.label_rounded)),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Center(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      SimpleDialog alert = SimpleDialog(
                                        title: const Text("Choose an action"),
                                        children: [
                                          SimpleDialogOption(
                                              onPressed: () {
                                                getImage(ImageSource.gallery);
                                              },
                                              child: const Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                        CupertinoIcons.photo,
                                                        color: Colors.blue),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 2),
                                                    child: Text(
                                                        "Pick from gallery",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  )
                                                ],
                                              )),
                                          SimpleDialogOption(
                                              onPressed: () {
                                                getImage(ImageSource.camera);
                                              },
                                              child: const Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 8),
                                                    child: Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                        "Capture from camera",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (context) => alert,
                                        barrierDismissible: true,
                                      );
                                    },
                                    icon: const Icon(Icons.image),
                                    label: const Text(
                                      "Choose shop image",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              )),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Text(
                              'Location Details',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              controller:locationController ,
                              readOnly: true,
                              onTap: () async {
                                debugPrint('you tapped me ');
                                LatLng? pickedLocation = await Navigator.push(context, MaterialPageRoute(builder: (context)=>const LocationPicker()));
                                if (pickedLocation != null) {
                                  String formattedLocation =
                                      '${pickedLocation.latitude},${pickedLocation.longitude}';
                                  setState(() {
                                    location = formattedLocation;
                                    locationController.text = '${pickedLocation.latitude.toStringAsFixed(4)},${pickedLocation.longitude.toStringAsFixed(4)}';
                                  });
                                } else {}
                              },

                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Location',
                                  prefixIcon:
                                      const Icon(Icons.location_on_rounded)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Text(
                              'Shop Timings',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              controller: startTimeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  String dummy = '';
                                  if (pickedTime.minute <= 9) {
                                    dummy = '0';
                                  }
                                  String formattedTime =
                                      '${pickedTime.hour}:$dummy${pickedTime.minute}';

                                  setState(() {
                                    startingTime = formattedTime;
                                    startTimeController.text = formattedTime;
                                  });
                                } else {}
                              },
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Opening Time',
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              controller: closeTimeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  String dummy = '';
                                  if (pickedTime.minute <= 9) {
                                    dummy = '0';
                                  }
                                  String formattedTime =
                                      '${pickedTime.hour}:$dummy${pickedTime.minute}';

                                  setState(() {
                                    closingTime = formattedTime;
                                    closeTimeController.text = formattedTime;
                                  });
                                } else {}
                              },
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Closing Time',
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined)),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                            child: Text(
                              'RazorPay Credentials',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              validator: (value) =>
                                  value == '' ? 'Field cannot be empty' : null,
                              onChanged: (value) {
                                setState(() {
                                  keyId = value;
                                });
                              },
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Key ID',
                                  prefixIcon: const Icon(Icons.key_rounded)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: TextFormField(
                              validator: (value) =>
                                  value == '' ? 'Field cannot be empty' : null,
                              onChanged: (value) {
                                setState(() {
                                  keySecret = value;
                                });

                              },

                              obscureText: hide,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Key Secret',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffix:IconButton(onPressed: (){hide=!hide;setState(() {

                                  });}, icon: Icon(hide?CupertinoIcons.eye:CupertinoIcons.eye_slash))
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

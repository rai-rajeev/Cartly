import 'package:cartly/screens/authentication/customer/customer_wrapper.dart';
import 'package:cartly/screens/authentication/shopkeeper/shopkeeper_wrapper.dart';
import 'package:cartly/screens/home.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:flutter/material.dart';



class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool? isCustomer;
  bool? isGoogleSignedIn;

  void checkIsGoogleSignedIn()async{
    bool? b = await SharedPrefs().isGoogleSignedIn();
    if(mounted){setState(() {
      isGoogleSignedIn = b;
    });}
  }

  void setIsCustomer() async {
    bool? b = await SharedPrefs().getIsCostumer();

    if(mounted){setState(() {
      isCustomer = b;
    });}
  }

  @override
  Widget build(BuildContext context) {
    setIsCustomer();


    if (isGoogleSignedIn == null) {
      return const Home(
        title: 'Cartly',
      );
    } else {
      return isCustomer! ? const CustomerWrapper() : const ShopkeeperWrapper();
    }
  }
}
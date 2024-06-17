import 'package:cartly/constant/loading.dart';
import 'package:cartly/screens/authentication/shopkeeper/shopkeeper_google_wrapper.dart';
import 'package:flutter/material.dart';
import '../../../Signin.dart';
import '../../../services/shared_prefs.dart';



class ShopkeeperWrapper extends StatefulWidget {
  const ShopkeeperWrapper({super.key});

  @override
  State<ShopkeeperWrapper> createState() => _ShopkeeperWrapperState();
}

class _ShopkeeperWrapperState extends State<ShopkeeperWrapper> {

  String? phone;
  bool done =false;

  void getPhoneFromPrefs()async{
    String? s = await SharedPrefs().getPhone();

    if(mounted){setState(() {
      phone = s;
      done=true;
    });}
  }

  @override
  Widget build(BuildContext context) {

    getPhoneFromPrefs();

    //final user = Provider.of<MyUser?>(context);
    if(!done){
      return const Loading();
    }
    if (phone != null) {
      return const ShopkeeperGoogleWrapper();
    } else {
      return const SignIn();
    }


  }
}
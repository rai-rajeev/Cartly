import 'package:cartly/constant/loading.dart';
import 'package:cartly/screens/authentication/shopkeeper/shopkeeper_form_wrapper.dart';
import 'package:cartly/screens/authentication/shopkeeper/shopkeeper_sign_in.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/src/widgets/framework.dart';
import '../../../services/shared_prefs.dart';

class ShopkeeperGoogleWrapper extends StatefulWidget {
  const ShopkeeperGoogleWrapper({super.key});

  @override
  State<ShopkeeperGoogleWrapper> createState() => _ShopkeeperGoogleWrapperState();
}

class _ShopkeeperGoogleWrapperState extends State<ShopkeeperGoogleWrapper> {


  bool done = false;

  bool? isGoogleSignedIn;

  void setIsGoogleSignedIn()async{
    bool? b = await SharedPrefs().isGoogleSignedIn();

    if(mounted){setState(() {
      isGoogleSignedIn = b;
      done=true;
    });}
  }

  @override
  Widget build(BuildContext context) {

    setIsGoogleSignedIn();
    if(!done){
      return Loading();
    }

    if(isGoogleSignedIn == null){
      //either logging out or no shop
      //shop created or not
      return const ShopkeeperSignIn();
    }
    else{
      //logged in (verification form or body)
      //check shop is created or not
      return const ShopkeeperFormWrapper();
    }
  }
}
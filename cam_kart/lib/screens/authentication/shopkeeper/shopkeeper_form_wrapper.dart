import 'package:cartly/constant/loading.dart';
import 'package:flutter/cupertino.dart';
import '../../../services/shared_prefs.dart';
import '../../shopkeeper_main_paige.dart';
import '../../shopkeeper_verification_form.dart';

class ShopkeeperFormWrapper extends StatefulWidget {
  const ShopkeeperFormWrapper({super.key});

  @override
  State<ShopkeeperFormWrapper> createState() => _ShopkeeperFormWrapperState();
}

class _ShopkeeperFormWrapperState extends State<ShopkeeperFormWrapper> {
  bool done =false;
  bool? isRestCreated;
  void setIsRestCreated()async{
    bool? b = await SharedPrefs().isRestCreated();

    if(mounted){setState(() {
      isRestCreated = b;
      done=true;
    });}
  }

  @override
  Widget build(BuildContext context) {

    setIsRestCreated();
    //print(isRestCreated);
    if(! done){
      return const Loading();
    }

    if(isRestCreated == true){
        return const MainPage();
    }
    else{
      return const ShopkeeperVerificationForm();
    }
  }







}

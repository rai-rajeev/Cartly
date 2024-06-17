import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constant/colors.dart';
import 'authentication/customer/customer_wrapper.dart';
import 'authentication/shopkeeper/shopkeeper_wrapper.dart';

class Home extends StatefulWidget {
  const Home({required this.title, super.key});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images.jpeg',
              ),
              fit: BoxFit.fill),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0, top: 150),
                child: Container(
                  child:  Text(
                    'CARTLY',
                    style: GoogleFonts.aBeeZee(textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                           // color: Color(0xffC1C8E4))
                          color: blackColor),
                    ),
                    // style:
                  ),
                ),
              ),
              Lottie.asset('assets/lottie/random2.json',
                  height: 300, width: 700),

              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20,),
                      child: Text("Sign in as:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const CustomerWrapper()));
                        },
                        style: ElevatedButton.styleFrom(
                           // backgroundColor: const Color(0xff5AB9EA),
                            minimumSize: const Size(300, 50)),
                        icon: const Icon(Icons.person,size: 45,),
                        label: const Text(
                          'Customer',
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      // padding: const EdgeInsets.only(top:20.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const ShopkeeperWrapper()));
                        },
                        style: ElevatedButton.styleFrom(
                            //backgroundColor: Colors.redAccent,
                            minimumSize: const Size(300, 50)),
                        icon: const Icon(Icons.store,size: 45,),
                        label: const Text(
                          'Shopkeeper',
                          style: TextStyle(fontSize: 28, ),
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

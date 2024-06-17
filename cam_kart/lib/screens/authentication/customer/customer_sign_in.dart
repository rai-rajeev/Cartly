import 'dart:ui';

import 'package:cartly/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../services/google_auth.dart';
import '../../../services/shared_prefs.dart';


class CustomerSignIn extends StatefulWidget {
  const CustomerSignIn({Key? key}) : super(key: key);

  @override
  State<CustomerSignIn> createState() => _CustomerSignInState();
}

class _CustomerSignInState extends State<CustomerSignIn> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final themeProvider=Provider.of<ThemeProvider>(context);
    return  Scaffold(

            body: Center(
              child: Stack(
                children: [
                  Image.asset('assets/bgi.png'),
                  Align(alignment: Alignment.bottomCenter,child: Image.asset('assets/bgi1.png')),
                  (themeProvider.isDarkMode)?Container(
                        width: double.infinity,
                        height: double.infinity,
                        color:themeProvider.isDarkMode? Colors.black.withOpacity(0.5):null, // Adjust opacity as needed
                      ):const SizedBox(height: 0,),


                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30),bottom: Radius.circular(30)),
                        border: Border.all(width: 3,color:themeProvider.isDarkMode? Colors.white:Colors.black)
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(
                              height: 20,
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 250,
                                  width: double.infinity,
                                  child: Lottie.asset('assets/signin1.json',
                                      repeat: true),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Welcome to Cartly!\nConnecting You to Local Eats',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aBeeZee(textStyle:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic)),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),

                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (loading)?const CircularProgressIndicator():ElevatedButton.icon(
                                        icon: Image.asset(
                                          'assets/google.png',
                                          width:40,
                                          height:40,
                                        ),
                                        label: const Text(
                                          'Sign in with Google',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          await SharedPrefs().setIsCustomer(true);
                                          final user = await GoogleAuthentication()
                                              .googleSignIn();
                                          print(user!.fullName);
                                          print('STEP 1');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                            backgroundColor: const Color(0xff5AB9EA),
                                          elevation: 5,
                                          side: const BorderSide(width: 0.8,color: Colors.white)
                                        )
                                      ),
                                    ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

}


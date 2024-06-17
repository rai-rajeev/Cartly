import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'auth.dart';
import 'screens/authentication/shopkeeper/otp_verification.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String verificationIdFinal = "";
  TextEditingController phoneNoController = TextEditingController();
  bool isloading = false;
  int? finaltoken;
  @override
  void initState() {
    super.initState();
    isloading = false;
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    isloading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images.jpeg'), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20, left: 18),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.8,
                child: LottieBuilder.asset("assets/lottie/auth.json"),
              ),
              const SizedBox(
                height: 35,
              ),
              BlurryContainer(
                color: Colors.white.withOpacity(0.4),
                blur: 2,
                elevation: 6,
                height: MediaQuery.of(context).size.height * .4,
                width: MediaQuery.of(context).size.width * .9,
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter your number ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: phoneNoController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Text(
                            ' +91 ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 0, minHeight: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!mounted) {
                            return;
                          }
                          if (!isloading) {
                            isloading = true;
                            setState(() {});
                            try {
                              bool done = await verification(
                                  "+91${phoneNoController.text.trim()}",
                                  context,
                                  setData);
                              debugPrint('$done');
                            } catch (e) {
                              isloading = false;
                              setState(() {});
                              debugPrint(e.toString());
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: (isloading)
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Send OTP',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void setData(String verificationId, int? token) {
    setState(() {
      verificationIdFinal = verificationId;
      finaltoken = token;
      isloading=false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOtpPage(phoneNo: '+91${phoneNoController.text.trim()}', verificationId: verificationId,token: token,)));
  }
}

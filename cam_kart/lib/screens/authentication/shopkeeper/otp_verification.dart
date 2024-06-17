import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cartly/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class VerifyOtpPage extends StatefulWidget {
  final String phoneNo;
  final String verificationId;
  final int? token;

  const VerifyOtpPage(
      {Key? key,
      required this.phoneNo,
      required this.verificationId,
      this.token})
      : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  TextEditingController pin1cont = TextEditingController();
  TextEditingController pin2cont = TextEditingController();
  TextEditingController pin3cont = TextEditingController();
  TextEditingController pin4cont = TextEditingController();
  TextEditingController pin5cont = TextEditingController();
  TextEditingController pin6cont = TextEditingController();
  bool canresend = false;
  String? veryid = "";
  int start = 30;
  bool wait = false;
  String verificationIdFinal = "";
  int? finaltoken;
  String smsCode = "";
  late Timer _timer;
  void startTimer() {
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    startTimer();
    wait=true;
    super.initState();
  }
  @override
  void dispose() {
    pin1cont.dispose();
    pin2cont.dispose();
    pin3cont.dispose();
    pin4cont.dispose();
    pin5cont.dispose();
    pin6cont.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images.jpeg'),fit: BoxFit.fill)),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top:22.0),
                  child: BackButton(color: Colors.black,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*.8,
                  margin: const EdgeInsets.only(top: 22,),
                  child: const Text(
                    'VERIFY YOUR OTP',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*.3,
              child: LottieBuilder.asset("assets/otp.json"),
            ),
            BlurryContainer(
              color: Colors.white.withOpacity(0.4),
              blur: 2,
              elevation: 10,
              height: MediaQuery.of(context).size.height * (wait?0.4:0.5),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'An OTP has been send to +91${widget.phoneNo[3]}******${widget.phoneNo.substring(10)}',
                    style:
                        const TextStyle(fontWeight: FontWeight.w400, fontSize: 25,color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Enter OTP ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin1cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin2cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin3cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin4cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin5cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 45,
                          child: TextFormField(
                            controller: pin6cont,
                            style: const TextStyle(color: Colors.black, fontSize: 30),
                            onChanged: (value) {
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center, // Center the text horizontally
                            textAlignVertical: TextAlignVertical.center, // Center the text vertically
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to center text vertically
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Send OTP again in ",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      TextSpan(
                        text: "00:${start~/10}${start%10}",
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      const TextSpan(
                        text: " sec ",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  wait
                      ? const SizedBox(
                          height: 0,
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SizedBox(
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (!mounted) {
                                      return;
                                    }
                                    startTimer();
                                    setState(() {
                                      start = 30;
                                      wait = true;
                                    });
                                    await verification(
                                        widget.phoneNo, context, setData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                          fontSize: 26, fontWeight: FontWeight.w500,color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                          onPressed: () async {
                            smsCode = pin1cont.text.trim() +
                                pin2cont.text.trim() +
                                pin3cont.text.trim() +
                                pin4cont.text.trim() +
                                pin5cont.text.trim() +
                                pin6cont.text.trim();
                            try {
                              await signInwithPhoneNumber(
                                  widget.verificationId, smsCode,
                                  context, widget.phoneNo);
                            }
                            catch(e){
                              debugPrint('$e');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w500,color: Colors.white ),
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setData(String verificationId, int? token) {
    setState(() {
      verificationIdFinal = verificationId;
      finaltoken = token;
    });

  }
}

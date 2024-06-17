import 'package:cartly/screens/authentication/shopkeeper/otp_verification.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<bool> verification(String str, BuildContext context, Function setdata) async {
  verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    showSnackBar(context, "Verification has been Completed");



  }
  verificationFailed(FirebaseAuthException exception) {
    showSnackBar(context, exception.toString());
  }
  codeSent(String verificationID, [int? forceResnedingtoken]) {
    showSnackBar(context, "Verification Code sent on the phone number");
    setdata(verificationID,forceResnedingtoken);
  }

  codeAutoRetrievalTimeout(String verificationID) {
    showSnackBar(context, "Time out");
  }
  try {
    // firebaseAuth.getFirebaseAuthSettings().setAppVerificationDisabledForTesting(true);
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: str,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

void storeTokenAndData(UserCredential userCredential) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print("storing token and data");
  sharedPreferences.setString(
      "tkn", userCredential.credential?.token.toString() ?? " ");
  sharedPreferences.setString("usercredential", userCredential.toString());
}

Future<void> signInwithPhoneNumber(
    String verificationId, String smsCode, BuildContext context, String phone) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    UserCredential userCredential =
    await firebaseAuth.signInWithCredential(credential);
    await SharedPrefs().savePhone(phone);
    print('SAVED NUMBER IN PREFS');
    storeTokenAndData(userCredential);
    Navigator.pop(context);
    showSnackBar(context, "logged In");
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}
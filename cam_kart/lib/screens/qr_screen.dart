import 'package:cartly/constant/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrScreen extends StatefulWidget {
  String orderId;
  QrScreen({Key? key,required this.orderId}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light
        ),
        elevation: 1,
        title: const modified_text(text: 'Cartly',size: 30,),
        centerTitle: true,
      ),
      body:Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: QrImageView(
            backgroundColor: Colors.white,
            data: widget.orderId,
            version: QrVersions.auto,
          ),
        ),
      ),
    );
  }
}
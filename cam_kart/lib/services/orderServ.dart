import 'dart:convert';
import 'dart:io';
import 'package:cartly/constant/constants.dart';
import 'package:cartly/model/dishInfo.dart';
import 'package:cartly/model/restInfo.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../constant/error_handling.dart';
import '../model/my_user.dart';
import '../model/orderInfo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

String uri = RD_URL;

class OrderServ {
  var client = http.Client();
  User cur=FirebaseAuth.instance.currentUser!;

  Future<String> uploadNewImage(File image, String id) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('/Dish/$id');
      firebase_storage.UploadTask uploadTask = ref.putFile(image.absolute);
      await Future.value(uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    } catch (e) {
      rethrow;
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Order> fetchOrderbyId(BuildContext context, String orderId) async {
    List<Order> OrderList = [];
    try {
      String token=(await cur.getIdToken())!;
      String url = '$RD_URL/food/order/$orderId.json?auth=$token';
      http.Response res = await client.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      },);
      var obj = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          OrderList.add(Order.fromJson(obj));
        },
      );
    } catch (e) {
      print(e);
    }

    return OrderList[0];
  }

  Future<bool> razorPayApiRefund(
      num amount, String paymentId, String keys) async {
    var auth = 'Basic ${base64Encode(utf8.encode(keys))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    var request = http.Request('POST',
        Uri.parse('https://api.razorpay.com/v1/payments/$paymentId/refund'));
    request.body = json.encode({'amount': amount * 100});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      debugPrint('refunded succesfully');
      return true;
    } else {
      throw Exception('error ${response.stream.toString()}');
    }
  }

  Future<Map<String, dynamic>> razorPayApi(
      num amount, String receiptId, String keys) async {
    var auth = 'Basic ${base64Encode(utf8.encode(keys))}';
    var headers = {'content-type': 'application/json', 'Authorization': auth};
    var request =
        http.Request('POST', Uri.parse('https://api.razorpay.com/v1/orders'));
    request.body = json.encode({
      // Amount in smallest unit
      // like in paise for INR
      "amount": amount * 100,
      // Currency
      "currency": "INR",
      // Receipt Id
      "receipt": receiptId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      return {
        "status": "success",
        "orderId": jsonDecode(await response.stream.bytesToString())['id'],
      };
    } else {
      return {"status": "fail", "message": (response.reasonPhrase)};
    }
  }

  Future<Map<String, dynamic>> checkout(
      BuildContext context, Order order) async {
    var razorPayKey = dotenv.get("key_id");
    var razorPaySecret = dotenv.get("sec_key");

    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await client
          .get(Uri.parse('$RD_URL/food/rest/${order.restaurantId}.json?auth=$token'));
      if (res.statusCode != 200) {
        throw Exception(' error! ${res.body}');
      } else {
        RestInfo info = RestInfo.fromJson(json.decode(res.body));
        debugPrint(info.razorpayCred.key_id);
        if (info.razorpayCred.key_id != '' &&
            info.razorpayCred.keySecret != '') {
          razorPayKey = info.razorpayCred.key_id;
          razorPaySecret = info.razorpayCred.keySecret;
        }

        return razorPayApi(
            order.total, order.restaurantId, '$razorPayKey:$razorPaySecret');
      }
    } catch (e) {
      print('QWERTYUI');
      print(e);
    }
    return {};
  }

  Future<void> acknowledge(
      BuildContext context, String orderId, String paymentId) async {
    try {
      String token=(await cur.getIdToken())!;
      String url = '$RD_URL/food/order/$orderId.json?auth=$token';
      http.Response res = await http.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json
              .encode({'paymentId': paymentId, 'Order_status': 'responsePending'}));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<Order>> fetchResponsePendingOrders(BuildContext context) async {
    final String restId = (await SharedPrefs().getRestId()) ?? '';

    List<Order> OrderList = [];

    try {
      String token=(await cur.getIdToken())!;
      String url =
          '$RD_URL/food/order.json?auth=$token&orderBy="restaurant_id"&equalTo="$restId"';
      http.Response res = await http.get(Uri.parse(url),headers: {
        'Content-Type': 'application/json',
      },);
      var obj = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) {
            if (v['Order_status'] == 'responsePending') {
              OrderList.add(Order.fromJson(v));
            }
          });
          // print(OrderList);
          //print("hi");
        },
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
      print("alpha");
      // showSnackBar(BuildContext, e.toString());
    }
    // print('xxx');
    return OrderList;
  }

  Future<List<Order>> fetchUserCart(BuildContext context) async {
    List<Order> OrderList = [];
    final user = Provider.of<MyUser?>(context, listen: false);
    try {
      // print('hello');
      String token=(await cur.getIdToken())!;
      String url =
          '$RD_URL/food/order.json?auth=$token&orderBy="user_id"&equalTo="${user!.uid}"';
      http.Response res = await client.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      },);
      debugPrint(res.body);
      var obj = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) {
            if (v['Order_status'] == 'paymentPending') {
              OrderList.add(Order.fromJson(v));
            }
          });
        },
      );
    } catch (e) {
      print(e);
      print("alpha");
    }

    return OrderList;
  }

//remember to return
  Future<List<Order>> fetchAcceptedOrders(BuildContext context) async {
    List<Order> OrderList = [];
    String id = await SharedPrefs().getRestId() ?? "";

    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await client.get(
          Uri.parse(
              '$uri/food/order.json?auth=$token&orderBy="restaurant_id"&equalTo="$id"'),
        headers: {
          'Content-Type': 'application/json',
        },);
      var obj = jsonDecode(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) {
            if (v['Order_status'] == 'accepted') {
              OrderList.add(Order.fromJson(v));
            }
          });
        },
      );
    } catch (e) {}
    return OrderList;
  }
  completeOrder(BuildContext context, String id) async{
    var snack;
    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await client.patch(Uri.parse('$uri/food/order/$id.json?auth=$token'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'Order_status': 'completed'}));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {

            print("success");
            snack = const SnackBar(
              content: Text('Order completed.'),
              backgroundColor: Colors.green,
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(5),
            );

        },
      );
    } catch (e) {
      snack = const SnackBar(
        content: Text('Irrelevant QR.'),
        backgroundColor: Colors.green,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(5),
      );
      print(e);
      print("alpha");
    }
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> AcceptOrders(BuildContext context, String id) async {
    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await client.patch(Uri.parse('$uri/food/order/$id.json?auth=$token'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'Order_status': 'accepted'}));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      print(e);
      print("alpha");
    }
  }

//yet to implement refund
  Future<void> RejectOrders(BuildContext context, Order order) async {
    try {
      String token=(await cur.getIdToken())!;
      var razorPayKey = dotenv.get("key_id");
      var razorPaySecret = dotenv.get("sec_key");
      http.Response res = await client
          .get(Uri.parse('$RD_URL/food/rest/${order.restaurantId}.json?auth=$token'),headers: {
        'Content-Type': 'application/json',
      },);
      if (res.statusCode != 200) {
        throw Exception(' error! $res');
      } else {
        RestInfo info = RestInfo.fromJson(json.decode(res.body));
        if (info.razorpayCred.key_id != '' &&
            info.razorpayCred.keySecret != '') {
          razorPayKey = info.razorpayCred.key_id;
          razorPaySecret = info.razorpayCred.keySecret;
        }
        bool done = await razorPayApiRefund(
            order.total, order.paymentId, '$razorPayKey:$razorPaySecret');
        if (done) {
          http.Response response = await http.patch(
            Uri.parse('$uri/food/order/${order.id}.json?auth=$token'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({'Order_status': 'rejected'}),
          );
          if(response.statusCode!=200){
            throw Exception(response.body);
          }
          httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {},
          );
        }
      }
    } catch (e) {
      print(e);
      print("alpha");
    }
  }

  Future<void> InOutStock(BuildContext context, DishInfo dish) async {
    try {
      String token=(await cur.getIdToken())!;
      http.Response res =
          await http.patch(Uri.parse('$uri/food/dish/${dish.id}.json?auth=$token'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode({'InStock': !dish.inStock}));
      if (res.statusCode != 200) {
        throw Exception('Error ${res.body}');
      }
    } catch (e) {

      print(e);
      print("alpha");
    }
  }

  Future<void> RemoveItem(BuildContext context, String id,RestInfo restaurant) async {
    try {
      // print('hello');
      String token=(await cur.getIdToken())!;
      http.Response res =
          await http.delete(Uri.parse('$uri/food/dish/$id.json?auth=$token'), headers: {
            'Content-Type': 'application/json',
          },);
      if(res.statusCode==200) {
        restaurant.menu!.remove(id);
        http.Response response=await http.patch(Uri.parse('$uri/food/rest/${restaurant.id}.json?auth=$token'),
          headers: {
            'Content-Type': 'application/json',
          },
            body: json.encode({'menu':restaurant.menu}),
        );
        if(response.statusCode!=200){
          throw Exception(response.body);
        }
      }
      else{
        throw Exception(res.body);
      }

    } catch (e) {
      print(e);
      print("alpha");
    }
  }

  Future<void> Createdish(
      BuildContext context, Map<String, dynamic> mymap,RestInfo restaurant) async {
    File? img = mymap['pic'];
    mymap['pic'] = '';

    try {
      String token=(await cur.getIdToken())!;
      var req = await http.post(Uri.parse('$uri/food/dish.json?auth=$token'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(mymap));
      if (req.statusCode == 200) {
        final body = json.decode(req.body);
        final id = body['name'];
        String imgUrl =img==null?DDI: await uploadNewImage(img, id);
        final res = await client.patch(Uri.parse('$uri/food/dish/$id.json?auth=$token'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({'id': id, 'pic': imgUrl}));

        if (res.statusCode != 200) {
          throw Exception('erorr! $res');
        }
        else{
          restaurant.menu!.add(id);
          http.Response res1=await client.patch(Uri.parse('$uri/food/rest/${restaurant.id}.json?auth=$token'),
              headers: {
                'Content-Type': 'application/json',
              },
            body:json.encode({'menu':restaurant.menu})

          );
          if(res1.statusCode!=200){
            throw Exception('$res1');
          }
        }

      }

      httpErrorHandle(
        response: req,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      print(e);
      print("alpha1233344");
    }
  }

  Future<List<Order>> fetchCompletedOrders(BuildContext context) async {
    List<Order> OrderList = [];
    final user = Provider.of<MyUser?>(context, listen: false);
    bool isCustomer = await SharedPrefs().getIsCostumer() ?? false;
    String orderBy = (isCustomer) ? "user_id" : "restaurant_id";
    String id = !(isCustomer)? (await SharedPrefs().getRestId())!:user!.uid;
    debugPrint('$id $orderBy');
    try {
      //print('hello');
      String token=(await cur.getIdToken())!;
      http.Response res = await http.get(
          Uri.parse('$uri/food/order.json?auth=$token&&orderBy="$orderBy"&equalTo="$id"'),
        headers: {
          'Content-Type': 'application/json',
        },);
      var obj = jsonDecode(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) {
            if (v['Order_status'] == 'completed') OrderList.add(Order.fromJson(v));
          });
        },
      );
    } catch (e) {}

    return OrderList;
  }

  Future<List<Order>> fetchRejectedOrders(BuildContext context) async {
    List<Order> OrderList = [];
    final user = Provider.of<MyUser?>(context, listen: false);
    bool isCustomer = await SharedPrefs().getIsCostumer() ?? false;
    String orderBy = (isCustomer) ? "user_id" : "restaurant_id";
    String id =!(isCustomer)? (await SharedPrefs().getRestId() )!: user!.uid;

    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await http.get(
          Uri.parse('$uri/food/order.json?auth=$token&orderBy="$orderBy"&equalTo="$id"'),
        headers: {
          'Content-Type': 'application/json',
        },);
      var obj = jsonDecode(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) {
            if (v['Order_status'] == 'rejected') OrderList.add(Order.fromJson(v));
          });
        },
      );
    } catch (e) {}

    return OrderList;
  }
}

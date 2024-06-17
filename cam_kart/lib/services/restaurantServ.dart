import 'dart:convert';
import 'dart:io';

import 'package:cartly/constant/constants.dart';
import 'package:cartly/model/shop_info.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constant/error_handling.dart';
import '../model/dishInfo.dart';
import '../model/my_user.dart';
import '../model/orderInfo.dart';
import '../model/restInfo.dart';

class RestaurantServ {
  var client = http.Client();
  User cur=FirebaseAuth.instance.currentUser!;
  Future<String> uploadNewImage(File image, String id) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('/Restaurant/$id');
      firebase_storage.UploadTask uploadTask = ref.putFile(image.absolute);
      await Future.value(uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    } catch (e) {
      rethrow;
    }
  }

  void postRestaurant(
      ShopVerificationInfo info, MyUser? user, File? _image) async {
    RestInfo data = RestInfo(
      id: '',
      pic:DRI,
      ownerName: user!.fullName!,
      restaurantName: info.shopName,
      phoneNumber: info.phoneNumber,
      email: user.email!,
      location: info.location,
      status: "on",
      razorpayCred: RazorpayCred(key_id:info.keyId,keySecret:info.secretKey),
      openingTime: info.startTime,
      closingTime: info.closeTime


    );
    String url = '$RD_URL/food/rest.json';
    try {
      // Make a POST request
      String token=(await cur.getIdToken())!;

      http.Response response = await client.post(
        Uri.parse('$url?auth=$token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data.toJson()),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        print('Push request sent successfully.');
        String id = json.decode(response.body)['name'];
        String imgUrl =_image==null?DRI: await uploadNewImage(_image, id);
        final res = await client.patch(
          Uri.parse('${url.substring(0, url.length - 5)}/$id.json?auth=$token'),
          headers:{
            'Content-Type': 'application/json',
          } ,
          body: json.encode({'pic': imgUrl,'id':id}),
        );
        if (res.statusCode != 200) {
          throw Exception('unexpected occurred');
        }
        //SharedPrefs().setToken(responsed.headers['token']!);
        final restID = id;
        print(restID);

        await SharedPrefs().setRestId(restID);
        await SharedPrefs().setRestCreated(true);
        if (response.statusCode == 200) {
          print('Data updated successfully');
        } else {
          print('Failed to update data. Status code: ${response.statusCode}');
        }
      } else {
        print(
            'Failed to send push request. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending push request: $e');
    }

    print(
        'SUCCESSsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
  }
  Future<void> changeStatus(BuildContext context ,String restId,String changedTo) async {
    String url = '$RD_URL/food/rest.json?';
    String token=(await cur.getIdToken())!;
    final res = await client.patch(
      Uri.parse('${url.substring(0, url.length - 5)}/$restId.json?auth=$token'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'status':changedTo}),
    );
    if (res.statusCode != 200) {
      throw Exception('unexpected occurred');
    }
  }

  Future<List<DishInfo>?> fetchMenu(BuildContext context, String restID) async {

    try {
      RestInfo restaurant = await fetchRestaurantsbyID(context, restID);

      List<DishInfo> result = await fetchDish(context, restaurant.menu);
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<List<RestInfo>> fetchAllRestaurants(BuildContext context) async {
    List<RestInfo> RestList = [];
    String token=(await cur.getIdToken())!;
    try {
      http.Response res =
          await client.get(Uri.parse('${RD_URL}/food/rest.json?auth=$token'),headers: {
            'Content-Type': 'application/json',
          },);
      var obj = jsonDecode(res.body);
      debugPrint('$obj');
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) => {RestList.add(RestInfo.fromJson(v))});
        },
      );
    } catch (e) {
      print(e);
      print("alpha1");
    }
    return RestList;
  }

  Future<List<RestInfo>> fetchOpenRestaurants(BuildContext context) async {
    List<RestInfo> RestList = [];
    try {
      String token=(await cur.getIdToken())!;
      http.Response res = await client.get(
          Uri.parse('$RD_URL/food/rest.json?auth=$token&orderBy="status"&equalTo="on"'),headers: {
        'Content-Type': 'application/json',
      },);
      var obj = jsonDecode(res.body);
      debugPrint('$obj');
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) => {RestList.add(RestInfo.fromJson(v))});
        },
      );
    } catch (e) {
      print(e);
      print("alpha2");
    }
    return RestList;
  }

  Future<List<RestInfo>> fetchSearchRestaurants(
      BuildContext context, String s) async {
    List<RestInfo> RestList = [];
    try {
      String token=(await cur.getIdToken())!;
      debugPrint('search started');
      http.Response res = await client.get(Uri.parse(
          '$RD_URL/food/rest.json?auth=$token&orderBy="restaurantName"&equalTo="$s"'),
        headers: {
        'Content-Type': 'application/json',
      },);
      var obj = jsonDecode(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          obj.forEach((k, v) => {RestList.add(RestInfo.fromJson(v))});
        },
      );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
      print("alpha3");
      // showSnackBar(BuildContext, e.toString());
    }
    return RestList;
  }

  Future<RestInfo> fetchRestaurantsbyID(
      BuildContext context, String restid) async {
    // final userProvider = Provider.of(context)
    List<RestInfo> RestList = [];
     try {
       String token=(await cur.getIdToken())!;

      http.Response res =
          await client.get(Uri.parse('$RD_URL/food/rest/$restid.json?auth=$token'),headers: {
            'Content-Type': 'application/json',
          },);
      var obj = jsonDecode(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //debugPrint('$obj');
          RestList.add(RestInfo.fromJson(obj));
        },
      );
    } catch (e) {
      print(e);
      print("alpha4");
      throw Exception('$e');
    }
    return RestList[0];
  }

  Future<List<DishInfo>> fetchDish(
      BuildContext context, List<String>? menu) async {
    List<DishInfo> dishes = [];
    try {
      if (menu == []) {
        return [];
      } else {
        String token=(await cur.getIdToken())!;
        for (int i = 0; i < menu!.length; i++) {
          http.Response res = await client
              .get(Uri.parse('$RD_URL/food/dish/${menu[i].toString()}.json?auth=$token'),headers: {
            'Content-Type': 'application/json',
          },);
          var obj = jsonDecode(res.body);

          httpErrorHandle(
            response: res,
            context: context,
            onSuccess: () {
              dishes.add(DishInfo.fromJson(obj));
            },
          );
        }
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
      print("alpha");
      // showSnackBar(BuildContext, e.toString());
    }
    return dishes;
  }
  Future<Map<String,int>> itemsInCartFromRes(RestInfo restaurant,BuildContext context) async {
    final user=Provider.of<MyUser>(context,listen: false);
    Map<String,int> ans={};
    String token=(await cur.getIdToken())!;
    http.Response r=await client.get(Uri.parse(
        '$RD_URL/food/order.json?auth=$token&orderBy="user_id"&equalTo="${user.uid}"'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if(r.statusCode==200){
      final obj=json.decode(r.body);
      obj.forEach((m,k){
        Order order=Order.fromJson(k);
        if(order.restaurantId==restaurant.id && order.orderStatus=='paymentPending'){
            for(int i=0;i<order.items.length;i++){
              if(ans.containsKey(order.items[i])){
                ans[order.items[i]] =(ans[order.items[i]])! + 1;
              }
              else{
                ans[order.items[i]]=1;
              }
            }
        }
      });
    }
    else{
      throw Exception(r.body);
    }

    return ans;
  }

  Future<void> postCartOrder(
      BuildContext context, DishInfo dish, ) async {
    final user = Provider.of<MyUser?>(context, listen: false);
     try {
       String token=(await cur.getIdToken())!;
      // for(int i=0;i<menu!.length;i++){
      http.Response r=await client.get(Uri.parse(
          '$RD_URL/food/order.json?auth=$token&orderBy="user_id"&equalTo="${user!.uid}"'),
        headers: {
        'Content-Type': 'application/json',
      },);
      if(r.statusCode==200){
        final obj=json.decode(r.body);
        Order? order;

        obj.forEach((k,v){
          Order ord=Order.fromJson(v);
          if(ord.restaurantId==dish.restId && ord.orderStatus=='paymentPending'){
            order=ord;
          }
        });
        if(order==null){
            Order order=Order(id: "", restaurantId: dish.restId!, userId: user.uid, items: [dish.id], total: dish.price!, timeOfOrder:DateTime.now().toString(), orderStatus: 'paymentPending', paymentId: '');
            http.Response re=await client.post(Uri.parse('$RD_URL/food/order.json?auth=$token'),
            headers: {
              'Content-Type': 'application/json',
            },body:json.encode(order.toJson()));
            if(re.statusCode==200){
              String id=json.decode(re.body)['name'];
              http.Response p=await client.patch(
                  Uri.parse('$RD_URL/food/order/$id.json?auth=$token'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({'id':id}));
              if(p.statusCode!=200){
                throw Exception(' from post cart order error!!!!\n ${p.body} ');
              }
            }
        }
        else{
          http.Response p=await client.patch(
              Uri.parse('$RD_URL/food/order/${order!.id}.json?auth=$token'),
              headers: {
    'Content-Type': 'application/json',
    },
              body: json.encode(
                  {'items':[...order!.items,dish.id],
                    'total':order!.total+dish.price!,
                    'timeOfOrder':DateTime.now().toString()
              }));
          if(p.statusCode!=200){
            throw Exception(' error!!!!\n $p ');
          }
        }
      }
      else{
        throw Exception('error \n $r ');
      }


    } catch (e) {
      debugPrint('$e');

      debugPrint("alpha5");
    }
  }

  Future<void> removeCartOrder(BuildContext context, DishInfo dish) async {
    // final userProvider = Provider.of(context)
    // DishInfo dish=new DishInfo(Rest_Id: 'jjbcnjk', name: 'kuchbhi', price: 99999, InStock: true);
    final user = Provider.of<MyUser?>(context, listen: false);
     // +
    //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc293bmVyIjpmYWxzZSwiaWQiOiI2M2VkMTU2ODBjNTdkZmQ0NGU5MWI0ZjciLCJpYXQiOjE2NzY0ODE4OTZ9.U7DldEuyTdCyX99xbQgpW8YWaCpibKsdfkVCT_7Ppdw';
    try {
      String token=(await cur.getIdToken())!;
      http.Response r=await client.get(Uri.parse(
          '$RD_URL/food/order.json?orderBy="user_id"&equalTo="${user!.uid}"?auth=$token'),
        headers: {
        'Content-Type': 'application/json',
      },);
      if(r.statusCode==200){
        final obj=json.decode(r.body);
        Order? order;

        obj.forEach((k,v){
          Order ord=Order.fromJson(v);
          if(ord.restaurantId==dish.restId && ord.orderStatus=='paymentPending'){
            order=ord;
          }
        });

        if(order!.items.length==1){
          http.Response re=await client.delete
            (Uri.parse('$RD_URL/food/order/${order!.id}.json?auth=$token'),
            headers: {
            'Content-Type': 'application/json',
          },);
          if(re.statusCode!=200){
            throw Exception(re.body);

          }
        }
        else{

          order!.items.remove(dish.id);
          http.Response p=await client.patch(
              Uri.parse('$RD_URL/food/order/${order!.id}.json?auth=$token'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode(
                  {'items':order!.items,
                    'total':order!.total-dish.price!,
                    'timeOfOrder':DateTime.now().toString()
                  }));
          if(p.statusCode!=200){
            throw Exception(' error!!!!\n ${p.body} ');
          }
        }
      }
      else{
        throw Exception('error \n ${r.body} ');
      }
    } catch (e) {
      debugPrint('$e');
      debugPrint("alpha");


    }
    // return dishes;
  }
}

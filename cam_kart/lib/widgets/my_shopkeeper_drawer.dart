import 'package:cartly/model/restInfo.dart';
import 'package:cartly/screens/shopkeeperOrderHistory.dart';
import 'package:cartly/services/restaurantServ.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/constants.dart';
import '../model/my_user.dart';
import '../screens/add_item_page.dart';
import '../screens/my_qr_screen.dart';
import '../services/google_auth.dart';
import '../theme_provider.dart';

class MyShopkeeperDrawer extends StatefulWidget {
  const MyShopkeeperDrawer({super.key, required this.restaurant});
  final RestInfo restaurant ;

  @override
  State<MyShopkeeperDrawer> createState() => _MyShopkeeperDrawerState();
}

class _MyShopkeeperDrawerState extends State<MyShopkeeperDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    final name = (user ?? dummyUser).fullName ?? 'user';
    final email = (user ?? dummyUser).email ?? 'email';
    final profile = (user ?? dummyUser).profile ?? '';


    return Drawer(
      width: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 60,
              foregroundImage: NetworkImage(profile),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              email,
            ),

            Container(
              height: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                        dense: true,
                        title:  Text('Dark Mode',style: drawerTextStyle(context),),
                        value: themeProvider.isDarkMode,
                        onChanged: (value)  {
                          themeProvider.toggleTheme();}
                    ),
                    div,
                    SwitchListTile(
                        dense: true,
                        title:  Text('Open Shop',style: drawerTextStyle(context),),
                        value:widget.restaurant.status=='on' ,
                        onChanged:(value ){
                          RestaurantServ().changeStatus(context, widget.restaurant.id, widget.restaurant.status=='on'?'off':'on');
                          widget.restaurant.status=widget.restaurant.status=='on'?'off':'on';
                          setState(() {

                          });
                        }),
                    div,
                    TextButton.icon(
                      onPressed: () {
                        //starting
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const MyQR();
                          },
                        ));
                        return;
                      },
                      style: drawerButtonStyle,
                      label:  Text('Scan QR',
                          style: drawerTextStyle(context)),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                    div,

                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  AddItem(restaurant: widget.restaurant,),
                              ));
                        },
                        style: drawerButtonStyle,
                        icon: const Icon(Icons.add,size: 28,),
                        label: Text('Add Items',style: drawerTextStyle(context))),
                    div,
                    TextButton.icon(
                      onPressed: () {Navigator.pop(context);Navigator.push(context, MaterialPageRoute(builder: (context)=>const CompletedOrdersScreen()));},
                      style: drawerButtonStyle,
                      label:  Text('Order History',style: drawerTextStyle(context)),
                      icon: const Icon(Icons.history),
                    ),
                    div,
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          GoogleAuthentication().googleLogout();
                        },
                        style: drawerButtonStyle,
                        icon: const Icon(Icons.logout),
                        label:  Text('Logout',style: drawerTextStyle(context))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
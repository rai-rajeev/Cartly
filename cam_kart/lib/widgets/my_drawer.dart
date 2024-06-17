import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../model/my_user.dart';
import '../screens/ordHistory.dart';
import '../screens/pendingOrders.dart';
import '../services/google_auth.dart';
import '../theme_provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
              style: const TextStyle(),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 0.8,
            ),
            div,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      dense: true,
                        title: Text('Dark Mode',style:drawerTextStyle(context),),
                        value: themeProvider.isDarkMode,
                        onChanged: (value)  {
                          themeProvider.toggleTheme();}
                    ),
                    div,
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdHistory(),
                            ));
                      },
                      style: drawerButtonStyle,
                      label: const Text('Order History'),
                      icon: const Icon(Icons.history_rounded),
                    ),
                    div,
                    TextButton.icon(
                      icon: const Icon(Icons.pending_actions_rounded),
                      label: const Text('Pending Orders'),
                      style: drawerButtonStyle,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PendHistory(),
                            ));
                      },
                    ),
                    div,
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          GoogleAuthentication().googleLogout();
                        },
                        style: drawerButtonStyle,
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout')),
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
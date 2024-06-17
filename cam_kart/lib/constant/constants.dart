import 'package:flutter/material.dart';

import '../model/my_user.dart';
//BrightNess Theme Colors
const Color kBrightPrimaryColor = Color(0xFF6200EA);
const Color kBrightPrimaryVariantColor = Color(0xFF3700B3);
const Color kBrightSecondaryColor = Color(0xFF03DAC6);
const Color kBrightSecondaryVariantColor = Color(0xFF018786);
Color kBrightBackgroundColor = Colors.grey[100]!;
const Color kBrightSurfaceColor = Color(0xFFFFFFFF);
const Color kBrightErrorColor = Color(0xFFB00020);
const Color kBrightOnPrimaryColor = Color(0xFFFFFFFF);
const Color kBrightOnSecondaryColor = Color(0xFF000000);
const Color kBrightOnBackgroundColor = Color(0xFF000000);
const Color kBrightOnSurfaceColor = Color(0xFF000000);
const Color kBrightOnErrorColor = Color(0xFFFFFFFF);

//Dark Theme colors
const Color kDarkPrimaryColor = Color(0xFFBB86FC);
const Color kDarkPrimaryVariantColor = Color(0xFF3700B3);
const Color kDarkSecondaryColor = Color(0xFF03DAC6);
const Color kDarkSecondaryVariantColor = Color(0xFF03DAC6);
Color kDarkBackgroundColor = Colors.grey[850]!;
const Color kDarkSurfaceColor = Color(0xFF696969);
const Color kDarkErrorColor = Color(0xFFCF6679);
const Color kDarkOnPrimaryColor = Color(0xFF000000);
const Color kDarkOnSecondaryColor = Color(0xFF000000);
const Color kDarkOnBackgroundColor = Color(0xFFFFFFFF);
const Color kDarkOnSurfaceColor = Color(0xFFFFFFFF);
const Color kDarkOnErrorColor = Color(0xFF000000);



final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F5F5),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFF000000),
    onSurface: Color(0xFF000000),
    onError: Color(0xFFFFFFFF),
  ),
  textTheme:  const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
    bodyLarge: TextStyle(fontSize: 20, color: Color(0xFF000000)),
    labelLarge: TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF6200EE),
      backgroundColor: const Color(0xFF03DAC6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1976D2),
    elevation: 4,
    titleTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFFFFFFFF),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    margin: const EdgeInsets.all(8),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6200EE),
    secondary: Color(0xFF03DAC6),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
    labelLarge: TextStyle(fontSize: 18, color: Color(0xFF000000)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color(0xFF6200EE),
      backgroundColor: const Color(0xFF03DAC6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: const TextStyle(fontSize: 18),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF6200EE),
    elevation: 4,
    titleTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20, fontWeight: FontWeight.bold),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF1E1E1E),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: const EdgeInsets.all(8),
  ),
);


final textInputDecoration = InputDecoration(
  //fillColor: Colors.white10,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.transparent)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.transparent)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.transparent)));

 TextStyle drawerTextStyle(BuildContext context) => const TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Color(0xFF6200EE)
  //color: Theme.of(context).primaryColor
);
 const div=Divider(thickness: .8,);

final drawerButtonStyle = ButtonStyle(
  fixedSize: MaterialStateProperty.all(const Size.fromWidth(double.maxFinite)),
  foregroundColor: MaterialStateProperty.all(const Color(0xFF6200EE)),
  alignment: Alignment.centerLeft,
);
const String DRI='https://firebasestorage.googleapis.com/v0/b/campus-catalogue-bd94d.appspot.com/o/WhatsApp%20Image%202024-06-13%20at%205.20.32%20PM.jpeg?alt=media&token=f6551613-1a4c-4a48-ac30-66e2b37e880a';
const String DDI='https://firebasestorage.googleapis.com/v0/b/campus-catalogue-bd94d.appspot.com/o/ddi.png?alt=media&token=d4e16641-721f-4048-9f54-913dfa6e9d7a';
MyUser dummyUser = MyUser(
    email: 'abc@email.com',
    apiKey: '',
    fullName: 'fullname',
    mobile: '1234567890',
    profile: '',
    uid: '');
const RD_URL='https://campus-catalogue-bd94d-default-rtdb.firebaseio.com/';

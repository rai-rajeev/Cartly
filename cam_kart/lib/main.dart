import 'package:cartly/services/auth_service.dart';
import 'package:cartly/services/shared_prefs.dart';
import 'package:cartly/theme_provider.dart';
import 'package:cartly/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'constant/constants.dart';
import 'firebase_options.dart';
import 'model/my_user.dart';
bool isDark=false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  isDark=await SharedPrefs().getTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key,});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return StreamProvider<MyUser?>.value(
            value: AuthService().user,
            initialData: null,

            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'CARTLY',
                theme: lightTheme,
                // theme: ThemeData(
                //   useMaterial3: true,
                //   brightness: Brightness.light,
                //   primaryColor: kBrightPrimaryColor,
                //   primaryColorDark: kBrightPrimaryVariantColor,
                //   textTheme: const TextTheme(
                //     displayLarge: TextStyle(color: kBrightOnBackgroundColor),
                //     displayMedium: TextStyle(color: kBrightOnBackgroundColor),
                //     bodyLarge: TextStyle(color: kBrightOnBackgroundColor),
                //     bodyMedium: TextStyle(color: kBrightOnBackgroundColor),
                //   ),
                //   colorScheme:  ColorScheme.light(
                //     primary: kBrightPrimaryColor,
                //     primaryContainer: kBrightPrimaryVariantColor,
                //     secondary: kBrightSecondaryColor,
                //     secondaryContainer: kBrightSecondaryVariantColor,
                //     background: kBrightBackgroundColor,
                //     surface: kBrightSurfaceColor,
                //     error: kBrightErrorColor,
                //     onPrimary: kBrightOnPrimaryColor,
                //     onSecondary: kBrightOnSecondaryColor,
                //     onBackground: kBrightOnBackgroundColor,
                //     onSurface: kBrightOnSurfaceColor,
                //     onError: kBrightOnErrorColor,
                //   ),),
                // colorSchemeSeed: const Color(0xffC1C8E4)),
                darkTheme:darkTheme,
                // darkTheme: ThemeData(
                //   useMaterial3: true,
                //   brightness: Brightness.dark,
                //   primaryColor: kDarkPrimaryColor,
                //   primaryColorDark: kDarkPrimaryVariantColor,
                //   textTheme: const TextTheme(
                //     displayLarge: TextStyle(color: kDarkOnBackgroundColor),
                //     displayMedium: TextStyle(color: kDarkOnBackgroundColor),
                //     bodyLarge: TextStyle(color: kDarkOnBackgroundColor),
                //     bodyMedium: TextStyle(color: kDarkOnBackgroundColor),
                //   ), colorScheme:ColorScheme.dark(
                //     primary: kDarkPrimaryColor,
                //     primaryContainer: kDarkPrimaryVariantColor,
                //     secondary: kDarkSecondaryColor,
                //     secondaryContainer: kDarkSecondaryVariantColor,
                //     background: kDarkBackgroundColor,
                //     surface: kDarkSurfaceColor,
                //     error: kDarkErrorColor,
                //     onPrimary: kDarkOnPrimaryColor,
                //     onSecondary: kDarkOnSecondaryColor,
                //     onBackground: kDarkOnBackgroundColor,
                //     onSurface: kDarkOnSurfaceColor,
                //     onError: kDarkOnErrorColor,
                //   ),),
                // colorSchemeSeed: const Color(0xff5AB9EA)),
                themeMode: themeProvider.themeMode,
                // home: CustomerSignIn(),
                home: const Wrapper()),
          );
        });
  }
}
import 'package:boat_shop/users/authentitaction/login_screen.dart';
import 'package:boat_shop/users/fragments/dashboard_of_fragments.dart';
import 'package:boat_shop/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Boat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapShot)
        {
          if(dataSnapShot.data == null)
          {
            return LoginScreen();
          }
          else
          {
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}






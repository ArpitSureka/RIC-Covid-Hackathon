import 'package:covid_app/constants.dart';
import 'package:covid_app/models/admin.dart';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/screens/announcements/announcements.dart';
import 'package:covid_app/screens/auth/adminlogin.dart';
import 'package:covid_app/screens/auth/edit_profile_screen.dart';
import 'package:covid_app/screens/auth/login_screen.dart';
import 'package:covid_app/screens/auth/profile_screen.dart';
import 'package:covid_app/screens/covid_map/map.dart';
import 'package:covid_app/screens/feedback/complaint_register.dart';
import 'package:covid_app/screens/home/admin/adminhome.dart';
import 'package:covid_app/screens/home/user/home_screen.dart';
import 'package:covid_app/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Initializing Firebase App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Checking if user previously logged in using SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  kMobileNumber = await prefs.getString('mobile');
  kEmail = await prefs.getString('email');
  //Check if user exists
  if (kMobileNumber != null) {
    kCurrUser = User(mobileNumber: kMobileNumber);
    await kCurrUser!.retrieveDocument();
    await kCurrUser!.downloadProfileImage();
  }
  //Check if admin exists
  if (kEmail != null) {
    kCurrAdmin = Admin(email: kEmail);
  }
  configLoading();
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'covid_app',
      home: (kCurrUser == null && kCurrAdmin == null)
          ? const WelcomeScreen()
          : (kCurrUser != null && kCurrAdmin == null)
              ? const HomeScreen()
              : const AdminHome(),
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        EditProfileScreen.id: (context) => EditProfileScreen(),
        MapScreen.id: (context) => MapScreen(),
        ComplaintScreen.id: (context) => ComplaintScreen(),
        AdminLoginScreen.id: (context) => AdminLoginScreen(),
        Announcements.id: (context) => Announcements(),
        AdminHome.id: (context) => AdminHome()
      },
      builder: EasyLoading.init(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

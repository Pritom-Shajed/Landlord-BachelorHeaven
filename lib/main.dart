import 'package:bachelor_heaven_landlord/bindings/bindings.dart';
import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/auth/auth_controller.dart';
import 'package:bachelor_heaven_landlord/view/auth/login.dart';
import 'package:bachelor_heaven_landlord/view/auth/registration.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/myProfile.dart';
import 'package:bachelor_heaven_landlord/view/intial/dashboard.dart';
import 'package:bachelor_heaven_landlord/view/intial/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bachelor Heaven Landlord',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(background: whiteColor),
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: '/splashScreen', page: ()=>SplashScreen()),
        GetPage(name: '/login', page: ()=>LoginScreen()),
        GetPage(name: '/registration', page: ()=>RegScreen()),
        GetPage(
          name: '/dashboard',
          page: () => Dashboard(),
        ),
        GetPage(name: '/myProfile', page: () => MyProfile())
      ],
      initialRoute: '/splashScreen',
      initialBinding: InitialBinding(),
    );
  }
}

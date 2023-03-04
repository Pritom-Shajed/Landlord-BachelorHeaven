import 'dart:async';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
     user == null ?  Get.offAllNamed('/login'): Get.offAllNamed('/dashboard');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150, child: Image.asset('assets/icons/icon.png')),
              Text(
                'For Landlord'.toUpperCase(),
                style: poppinsTextStyle(size: 14, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 80,child: Lottie.asset('assets/lottie/loading.json',)),
            ],
          ),
        ),
      ),
    );
  }
}

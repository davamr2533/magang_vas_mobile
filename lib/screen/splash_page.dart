import 'package:flutter/material.dart';
import 'package:vas_reporting/main.dart';
import 'package:tbib_splash_screen/splash_screen.dart';
import 'package:vas_reporting/screen/login_page.dart';


class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: const SplashScreenView(
        navigateRoute: LoginPage(),
        pageRouteTransition: PageRouteTransition.Normal,
        duration: Duration(seconds: 3),
        imageSrc: "assets/logo.png",
        logoSize: 120,
        backgroundColor: Colors.white, 
      ),
    );
  }
}
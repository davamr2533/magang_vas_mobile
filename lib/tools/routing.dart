import 'package:flutter/cupertino.dart';

Route routingPage(Widget routeScreen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => routeScreen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Optional fade animation
      var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

      return FadeTransition(
        opacity: fadeAnimation,
        child: child,
      );
    },
  );
}
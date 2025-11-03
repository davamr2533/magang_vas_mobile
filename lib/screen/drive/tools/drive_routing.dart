import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

enum RoutingTransitionType {
  zoom,
  slide,
}

class DriveRouting<T> extends PageRouteBuilder<T> {
  final Widget page;
  final RoutingTransitionType transitionType;

  DriveRouting({
    required this.page,
    this.transitionType = RoutingTransitionType.zoom,
  }) : super(
    opaque: transitionType == RoutingTransitionType.slide, // slide full page
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case RoutingTransitionType.zoom:
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: Colors.white,
            child: child,
          );


        case RoutingTransitionType.slide:
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));

          return SlideTransition(
            position: animation.drive(tween),
            child: Material(
              type: MaterialType.transparency, // atau gunakan type: MaterialType.canvas
              color: Colors.white,               // pastikan background putih
              child: child,
            ),
          );


      }
    },
  );

}


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;

class AppWidget {
  
  Widget LoadingWidget() {
    return Center(
      child: SpinKitWaveSpinner(
        color:baseColors.primaryColor,
        size: 50.0,
      ),
    );
  }
}
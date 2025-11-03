import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_reporting/tools/routing.dart';
import 'package:vas_reporting/base/base_colors.dart' as baseColors;
import 'package:vas_reporting/tools/routing.dart';

class PopUpWidget{
  final BuildContext context;
  PopUpWidget(this.context);
  
  Future pickPicture(void functionGallery(), void functionCamera()) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              functionGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              functionCamera();
            },
          ),
        ],
      ),);
    }
    showAlertFunctionOptions(String title, String content, String action1, String action2, VoidCallback routeScreen1, VoidCallback routeScreen2) {
        showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
          title: Text(title,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
          ),
          content: Text(content,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: Colors.black,
          ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(action1,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: baseColors.primaryColor,
                fontWeight: FontWeight.w500
              ),
              ),
              onPressed: () {
              routeScreen1();
              },
            ),
            CupertinoDialogAction(
              child: Text(action2,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: baseColors.primaryColor,
                fontWeight: FontWeight.w500
              ),
              ),
              onPressed: () {
                routeScreen2();
              },
            )
          ],
        );}
      );
    }
    showAlert(String title, String content, bool action, String actionText, Widget routeScreen) {
      showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
        title: Text(title,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500
        ),
        ),
        content: Text(content,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          color: Colors.black,
        ),
        ),
        actions: <Widget>[
          action 
          ?
          CupertinoDialogAction(
            child: Text(actionText,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              color: baseColors.primaryColor,
              fontWeight: FontWeight.w500
            ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                routingPage(routeScreen)
              );
            },
          )
          :
          SizedBox()
        ],
      );}
    );
    }

    showAlertWidget(String title, Widget content, String? actionText, String actionText2, Widget? routeScreen, Widget routeScreen2) {
      showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
        title: Text(title,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500
        ),
        ),
        content: content,
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('${actionText2}',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w500
            ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                routingPage(routeScreen2)
              );
            },
          ),
          if (actionText != null && actionText.isNotEmpty)
          CupertinoDialogAction(
            child: Text(actionText,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w500
            ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                routingPage( routeScreen ?? routeScreen2)
              );
            },
          ),
        ],
      );}
    );
    }

    showAlertWidgetApproval(String title, Widget content,Widget routeScreen, Widget routeScreen2) {
      showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
        title: Text(title,
        style: GoogleFonts.urbanist(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500
        ),
        ),
        content: content,
        actions: <Widget>[
        
          routeScreen2,
          routeScreen,
          CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('Cancel',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: Colors.orange,
              fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      );
      }
    );
  }
}
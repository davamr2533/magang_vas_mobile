import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vas_reporting/screen/task_track/task_track_vas/track_vas_page.dart';
import 'package:vas_reporting/tools/routing.dart';

class TaskHistoryPage extends StatefulWidget {
  const TaskHistoryPage({super.key});

  @override
  State<TaskHistoryPage> createState() => _TaskHistoryPage();
}

class _TaskHistoryPage extends State<TaskHistoryPage> {

  @override
  Widget build(BuildContext context) {

    //Mapping route back dari android
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacement(
          routingPage(const TrackVasPage()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                routingPage(const TrackVasPage()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("History"),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),

      ),
    );
  }

}
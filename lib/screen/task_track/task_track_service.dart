import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskTrackService {

  //API untuk get data dari tabel activity_task_tracker
  static const String getTaskTrackerURL = "http://202.169.231.66:82/api/v1/vas/get-task-tracker";


  //Method untuk mengembalikan data dari JSON
  Future<Map<String, dynamic>?> getTaskTracker() async {
    final token = await SharedPref.getToken();

    final response = await http.get(
      Uri.parse(getTaskTrackerURL),
      headers: {
        'Content-Type': 'application/json', //label jika yang dikirim/diterima berupa JSON
        'Authorization': 'Bearer $token', //untuk otorisasi berdasarkan user
      },
    );

    //jika response nya 200 OK maka data berhasil diambil
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

}
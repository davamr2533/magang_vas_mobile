import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskTrackService {

  //API untuk get data dari tabel activity_task_tracker
  static const String getTaskTrackerURL = "http://202.169.231.66:82/api/v1/vas/get-task-tracker";

  //API untuk update progress task tracker ke tabel activity_task_tracker
  static const String updateTaskTrackerURL = "http://202.169.231.66:82/api/v1/vas/update-progress-task";


  //Method untuk get data dari tabel task tracker
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

  //Method untuk update progress
  Future<bool> updateTaskTracker({
    required String nomorPengajuan,
    required String taskClosed,
    required String taskProgress,
    required String catatan,
    required String updatedBy,
  }) async {
    final token = await SharedPref.getToken();

    final body = {
      "nomor_pengajuan": nomorPengajuan,
      "task_closed": taskClosed,
      "task_progress": taskProgress,
      "catatan": catatan,
      "updated_by": updatedBy,
    };

    final response = await http.post(
      Uri.parse(updateTaskTrackerURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"] == "success";
    } else {
      return false;
    }


  }
}
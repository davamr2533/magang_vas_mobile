import 'dart:io';

import 'package:vas_reporting/utllis/app_shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskTrackService {

  //API untuk get data dari tabel activity_task_tracker
  static const String getTaskTrackerURL = "http://202.169.224.27:8081/api/v1/vas/get-task-tracker";

  //API untuk update progress task tracker ke tabel activity_task_tracker
  static const String updateTaskTrackerURL = "http://202.169.224.27:8081/api/v1/vas/update-progress-task";

  //API untuk get data dari tabel history
  static const String getHistoryTaskURL = "http://202.169.224.27:8081/api/v1/vas/get-history";


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

    //jika response nya 201 OK maka data berhasil diambil
    if (response.statusCode == 201) {
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
    File? foto1,
    File? foto2,
    File? foto3,
  }) async {
    try {
      final token = await SharedPref.getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(updateTaskTrackerURL),
      );

      // Header
      request.headers['Authorization'] = 'Bearer $token';

      // Fields (text)
      request.fields['nomor_pengajuan'] = nomorPengajuan;
      request.fields['task_closed'] = taskClosed;
      request.fields['task_progress'] = taskProgress;
      request.fields['catatan'] = catatan;
      request.fields['updated_by'] = updatedBy;

      // Files
      if (foto1 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto1',
          foto1.path,
        ));
      }

      if (foto2 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto2',
          foto2.path,
        ));
      }

      if (foto3 != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto3',
          foto3.path,
        ));
      }

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 201) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);

        return data["status"] == "success";
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }


  //Method untuk get data dari tabel History
  Future<Map<String, dynamic>?> getTaskHistory() async {
    final token = await SharedPref.getToken();

    final response = await http.get(
      Uri.parse(getHistoryTaskURL),
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
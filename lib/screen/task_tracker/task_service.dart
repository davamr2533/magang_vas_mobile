import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vas_reporting/base/base_paths.dart';
import 'package:vas_reporting/data/model/response/get_data_response.dart' as data;
import 'package:vas_reporting/data/model/response/get_data_vas_response.dart' as timeline;



class TaskService {


  //Koneksi untuk ambil data pengajuan
  static Future<List<data.Data>> fetchTasks(String token) async {
    if (token.trim().isEmpty) {
      throw Exception('Auth token kosong. Pastikan user sudah login.');
    }

    try {
      final response = await http.get(
        Uri.parse(urlGetAllData),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );



      //Jika Koneksi terhubung
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final result = data.GetDataResponse.fromJson(jsonResponse);

        //ambil pengajuan yang statusnya progress
        final taskProgressOnly = (result.data ?? [])
            .where((task) => task.statusAjuan?.toLowerCase() == "progress")
            .toList();

        return taskProgressOnly;

      //Jika Koneksi gagal
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized (401). Token tidak valid atau sudah kadaluarsa.');
      } else {
        throw Exception(
            'Gagal load data, status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {

      throw Exception('TaskService.fetchTasks error: $e');
    }
  }



  //Koneksi untuk ambil data vas
  static Future<List<timeline.Data>> fetchTimelines(String token) async {
    if (token.trim().isEmpty) {
      throw Exception('Auth token kosong. Pastikan user sudah login.');
    }

    try {
      final response = await http.get(
        Uri.parse(urlGetAllData), // pastikan URL ini udah ada di base_paths.dart
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final result = timeline.GetDataVasResponse.fromJson(jsonResponse);

        return result.data ?? [];

      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized (401). Token tidak valid atau sudah kadaluarsa.');
      } else {
        throw Exception('Gagal load timeline, status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      throw Exception('TaskService.fetchTimelines error: $e');
    }
  }
}
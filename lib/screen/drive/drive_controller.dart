import 'dart:convert';
import 'package:http/http.dart' as http;

class DriveController {
  final String baseUrl = "https://example.com/api"; // Ganti dengan URL API kamu

  // Fungsi untuk menambah atau menghapus bintang pada file/folder
  Future<bool> toggleStar({
    required int id,
    required bool isStarred,
    required bool isFolder,
  }) async {
    final endpoint = isFolder ? "toggle_star_folder.php" : "toggle_star_file.php";

    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      body: {
        'id': id.toString(),
        'starred': isStarred ? '1' : '0',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    return false;
  }

  //Fungsi untuk mengganti nama file/folder
  Future<bool> renameItem({
    required int id,
    required String newName,
    required bool isFolder,
  }) async {
    final endpoint = isFolder ? "rename_folder.php" : "rename_file.php";

    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      body: {
        'id': id.toString(),
        'new_name': newName,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    return false;
  }
}

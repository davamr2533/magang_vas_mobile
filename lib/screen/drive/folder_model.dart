class FolderModel {
  final int id;
  final String namaFolder;
  final String createdAt;

  FolderModel({
    required this.id,
    required this.namaFolder,
    required this.createdAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      namaFolder: json['namaFolder'],
      createdAt: json['createdAt'],
    );
  }
}
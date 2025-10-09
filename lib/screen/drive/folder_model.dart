class FolderModel {
  final int id;
  final String namaFolder;
  final DateTime createdAt;
  final List<FolderModel> children;
  final bool isSpecial;
  final bool isStarred;

  FolderModel({
    required this.id,
    required this.namaFolder,
    required this.createdAt,
    this.children = const [],
    this.isSpecial = false,
    this.isStarred = false
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      namaFolder: json['namaFolder'],
      createdAt: DateTime.parse(json['createdAt']),
      isStarred: json['is_starred'] is bool
          ? json['is_starred']
          : (json['is_starred']?.toString().toLowerCase() == 'true'),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => FolderModel.fromJson(e))
          .toList() ??
          [],
    );
  }

}

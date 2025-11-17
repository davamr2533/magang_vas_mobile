enum DriveItemType {
  folder,
  file
}
class DriveItemModel {
  final int id;
  final int? parentId;
  final String? parentName;
  final String? userId;
  final DriveItemType type;
  final String nama;
  final DateTime createdAt;
  final DateTime updateAt;
  final bool isStarred;
  final bool isTrashed;
  final List<DriveItemModel> children;
  final String? mimeType;
  final String? size;
  final String? url;
  final bool isSpecial;

  DriveItemModel({
    required this.id,
    required this.type,
    required this.nama,
    required this.createdAt,
    required this.updateAt,
    this.parentId,
    this.parentName,
    this.userId,
    this.isSpecial = false,
    this.isStarred = false,
    this.isTrashed = false,
    this.children = const [],
    this.mimeType,
    this.size,
    this.url,
  });
}

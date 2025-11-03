import 'package:json_annotation/json_annotation.dart';

part 'get_data_drive_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GetDataDriveResponse {
  String? status;
  String? message;
  List<FolderItem>? data;

  GetDataDriveResponse({this.status, this.message, this.data});

  // Factory constructor untuk membuat instance dari JSON.
  factory GetDataDriveResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDataDriveResponseFromJson(json);

  // Method untuk mengubah instance menjadi JSON.
  Map<String, dynamic> toJson() => _$GetDataDriveResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class FolderItem {
  int? id;
  int? parentId;
  String? userId;
  String? name;
  String? isStarred; // Disimpan sebagai String, dikonversi via extension
  String? isTrashed; // Disimpan sebagai String, dikonversi via extension
  String? createdAt; // Disimpan sebagai String, dikonversi via extension
  String? updatedAt; // Disimpan sebagai String, dikonversi via extension
  List<FolderItem>? children;
  List<FileItem>? files;

  FolderItem({
    this.id,
    this.parentId,
    this.userId,
    this.name,
    this.isStarred,
    this.isTrashed,
    this.createdAt,
    this.updatedAt,
    this.children,
    this.files,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) =>
      _$FolderItemFromJson(json);

  Map<String, dynamic> toJson() => _$FolderItemToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class FileItem {
  int? id;
  int? parentId;
  String? userId;
  String? name;
  String? mimeType;
  String? size;
  String? urlFile;
  String? isStarred;
  String? isTrashed;
  String? createdAt;
  String? updatedAt;

  FileItem({
    this.id,
    this.parentId,
    this.userId,
    this.name,
    this.mimeType,
    this.size,
    this.urlFile,
    this.isStarred,
    this.isTrashed,
    this.createdAt,
    this.updatedAt,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) =>
      _$FileItemFromJson(json);

  Map<String, dynamic> toJson() => _$FileItemToJson(this);
}

//=============== EXTENSIONS =================
// Extension untuk mempermudah konversi tipe data.

extension FolderItemExtension on FolderItem {
  /// Mengonversi `isStarred` (String) menjadi `bool`.
  bool get isStarred => this.isStarred == 'TRUE';

  /// Mengonversi `isTrashed` (String) menjadi `bool`.
  bool get isTrashed => this.isTrashed == 'TRUE';

  /// Mencoba mem-parsing `createdAt` (String) menjadi `DateTime`. Mengembalikan null jika gagal.
  DateTime? get createdAtAsDate {
    if (createdAt == null) return null;
    try {
      return DateTime.parse(createdAt!);
    } catch (_) {
      return null;
    }
  }

  DateTime? get updatedAtAsDate {
    if (updatedAt == null) return null;
    try {
      return DateTime.parse(updatedAt!);
    } catch (_) {
      return null;
    }
  }
}

extension FileItemExtension on FileItem {
  /// Mengonversi `isStarred` (String) menjadi `bool`.
  bool get isStarred => this.isStarred == 'TRUE';

  /// Mengonversi `isTrashed` (String) menjadi `bool`.
  bool get isTrashed => this.isTrashed == 'TRUE';

  /// Mencoba mem-parsing `createdAt` (String) menjadi `DateTime`. Mengembalikan null jika gagal.
  DateTime? get createdAtAsDate {
    if (createdAt == null) return null;
    try {
      return DateTime.parse(createdAt!);
    } catch (_) {
      return null;
    }
  }

  DateTime? get updatedAtAsDate {
    if (updatedAt == null) return null;
    try {
      return DateTime.parse(updatedAt!);
    } catch (_) {
      return null;
    }
  }
}

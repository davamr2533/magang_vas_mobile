class UjiResponse {
  final String nomorPengajuan;
  final String currentProgress;
  final String? updatedBy;
  final String? catatan;
  final String updatedAt;
  final List<UjiTimeline> timeline;

  UjiResponse({
    required this.nomorPengajuan,
    required this.currentProgress,
    this.updatedBy,
    this.catatan,
    required this.updatedAt,
    required this.timeline,
  });

  factory UjiResponse.fromJson(Map<String, dynamic> json) {
    return UjiResponse(
      nomorPengajuan: json['nomor_pengajuan'],
      currentProgress: json['current_progress'],
      updatedBy: json['updated_by'],
      catatan: json['catatan'],
      updatedAt: json['updated_at'],
      timeline: (json['timeline'] as List)
          .map((e) => UjiTimeline.fromJson(e))
          .toList(),
    );
  }
}

class UjiTimeline {
  final String tahap;
  final String isDone;
  final String? updatedAt;

  UjiTimeline({required this.tahap, required this.isDone, this.updatedAt});

  factory UjiTimeline.fromJson(Map<String, dynamic> json) {
    return UjiTimeline(
      tahap: json['tahap'],
      isDone: json['isDone'],
      updatedAt: json['updated_at'],
    );
  }
}

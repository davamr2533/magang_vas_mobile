//class model untuk response data task tracker
class TaskTrackResponse {
  final String nomorPengajuan;
  final String currentProgress;
  final String jenis;
  final String divisi;
  final String? updatedBy; //nullable
  final String? catatan; //nullable
  final String updatedAt;
  final List<TaskTrackTimeline> timeline;

  TaskTrackResponse({
    required this.nomorPengajuan,
    required this.currentProgress,
    required this.jenis,
    required this.divisi,
    this.updatedBy,
    this.catatan,
    required this.updatedAt,
    required this.timeline,
  });

  // Factory constructor untuk parsing JSON ke objek TaskTrackResponse.
  factory TaskTrackResponse.fromJson(Map<String, dynamic> json) {
    //ambil field dari json
    return TaskTrackResponse(
      nomorPengajuan: json['nomor_pengajuan'],
      currentProgress: json['current_progress'],
      jenis: json['jenis'],
      divisi: json['divisi'],
      updatedBy: json['updated_by'],
      catatan: json['catatan'],
      updatedAt: json['updated_at'],
      timeline: (json['timeline'] as List)
        .map( (e) => TaskTrackTimeline.fromJson(e) )
        .toList()

    );
  }

}


//class model untuk detail tahapan progress (nested di dalam TaskTrackResponse).
class TaskTrackTimeline {
  final String tahap;
  final String isDone;
  final String? updatedAt;

  TaskTrackTimeline({
    required this.tahap,
    required this.isDone,
    this.updatedAt,
  });

  // Factory constructor untuk parsing JSON ke objek TaskTrackTimeline.
  factory TaskTrackTimeline.fromJson(Map<String, dynamic> json) {
    //ambil field dari json
    return TaskTrackTimeline(
      tahap: json['tahap'],
      isDone: json['isDone'],
      updatedAt: json['updated_at'],
    );
  }
}

class TaskHistoryResponse {
  final String historyNomorPengajuan;
  final String historyJenis;
  final String historyDivisi;
  final String historyFinishedAt;

  TaskHistoryResponse({
    required this.historyNomorPengajuan,
    required this.historyJenis,
    required this.historyDivisi,
    required this.historyFinishedAt
  });


  factory TaskHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TaskHistoryResponse(
      historyNomorPengajuan: json['nomor_pengajuan'],
      historyJenis: json['jenis'],
      historyDivisi: json['divisi'],
      historyFinishedAt: json['finished_at'],
    );
  }

}










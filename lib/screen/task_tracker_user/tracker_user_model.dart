class Task {
  final String idPengajuan;
  final String tahapPengajuan;
  final String divisi;
  final String namaPengajuan;
  final String tanggal;
  final int persentase;
  final String image;
  final bool isDone;
  final List<TimelineStep> timeline;

  Task({
    required this.idPengajuan,
    required this.tahapPengajuan,
    required this.divisi,
    required this.namaPengajuan,
    required this.tanggal,
    required this.persentase,
    required this.image,
    this.isDone = false,
    this.timeline = const [],
  });

  //simulasi pura pura ambil dari API (dummy JSON) :v
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      idPengajuan: json["idPengajuan"],
      tahapPengajuan: json["tahapPengajuan"],
      divisi: json["divisi"],
      namaPengajuan: json["namaPengajuan"],
      tanggal: json["tanggal"],
      persentase: json["persentase"],
      image: json["image"],
      isDone: json["isDone"] ?? false,
      timeline: (json["timeline"] as List<dynamic>?)
          ?.map((e) => TimelineStep.fromJson(e))
          .toList() ??
          [],
    );

  }
}


class TimelineStep {
  final String title;
  final String date;
  final bool isDone;

  TimelineStep({
    required this.title,
    required this.date,
    required this.isDone
  });

  factory TimelineStep.fromJson(Map<String, dynamic> json) {
    return TimelineStep(
        title: json["title"],
        date: json["date"],
        isDone: json["isDone"]
    );
  }

}
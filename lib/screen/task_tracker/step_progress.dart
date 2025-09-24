class StepProgress {
  final String title;
  final String? date;

  StepProgress(this.title, this.date);

  bool get isDone => date != null && date!.isNotEmpty; // true kalau sudah ada tanggal
}
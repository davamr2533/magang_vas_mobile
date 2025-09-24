import 'package:json_annotation/json_annotation.dart';

part 'get_data_vas_response.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake)

class GetDataVasResponse {
  String? status;
  String? message;
  List<Data>? data;

  GetDataVasResponse({this.status, this.message, this.data});

  GetDataVasResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? nomorPengajuan;
  String? pengerjaan;
  String? diterimaOleh;
  String? disetujuiOleh;
  String? wawancara;
  String? konfirmasiDesain;
  String? perancanganDatabase;
  String? pengembanganSoftware;
  String? debugging;
  String? testing;
  String? trial;
  String? production;
  String? createdAt;

  Data(
      {this.id,
      this.nomorPengajuan,
      this.pengerjaan,
      this.diterimaOleh,
      this.disetujuiOleh,
      this.wawancara,
      this.konfirmasiDesain,
      this.perancanganDatabase,
      this.pengembanganSoftware,
      this.debugging,
      this.testing,
      this.trial,
      this.production,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomorPengajuan = json['nomor_pengajuan'];
    pengerjaan = json['pengerjaan'];
    diterimaOleh = json['diterima_oleh'];
    disetujuiOleh = json['disetujui_oleh'];
    wawancara = json['wawancara'];
    konfirmasiDesain = json['konfirmasi_desain'];
    perancanganDatabase = json['perancangan_database'];
    pengembanganSoftware = json['pengembangan_software'];
    debugging = json['debugging'];
    testing = json['testing'];
    trial = json['trial'];
    production = json['production'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nomor_pengajuan'] = this.nomorPengajuan;
    data['pengerjaan'] = this.pengerjaan;
    data['diterima_oleh'] = this.diterimaOleh;
    data['disetujui_oleh'] = this.disetujuiOleh;
    data['wawancara'] = this.wawancara;
    data['konfirmasi_desain'] = this.konfirmasiDesain;
    data['perancangan_database'] = this.perancanganDatabase;
    data['pengembangan_software'] = this.pengembanganSoftware;
    data['debugging'] = this.debugging;
    data['testing'] = this.testing;
    data['trial'] = this.trial;
    data['production'] = this.production;
    data['created_at'] = this.createdAt;
    return data;
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

}



extension TimelineExtension on Data {
  List<TimelineStep> get timelineSteps {
    return [
      TimelineStep(
        title: 'Wawancara',
        date: wawancara ?? '-',
        isDone: (wawancara?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Konfirmasi Desain',
        date: konfirmasiDesain ?? '-',
        isDone: (konfirmasiDesain?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Perancangan Database',
        date: perancanganDatabase ?? '-',
        isDone: (perancanganDatabase?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Pengembangan Software',
        date: pengembanganSoftware ?? '-',
        isDone: (pengembanganSoftware?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Debugging',
        date: debugging ?? '-',
        isDone: (debugging?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Testing',
        date: testing ?? '-',
        isDone: (testing?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Trial',
        date: trial ?? '-',
        isDone: (trial?.isNotEmpty ?? false),
      ),
      TimelineStep(
        title: 'Production',
        date: production ?? '-',
        isDone: (production?.isNotEmpty ?? false),
      ),
    ];
  }
}


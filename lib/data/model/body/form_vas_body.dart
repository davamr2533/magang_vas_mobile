import 'package:json_annotation/json_annotation.dart';

part 'form_vas_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FormVasBody {
  String? status;
  String? nomor;
  String? pengerjaan;
  String? diterimaOleh;
  String? disetujuiOleh;
  String? catatan;
  String? wawancara;
  String? konfirmasiDesain;
  String? perancanganDatabase;
  String? pengembanganSoftware;
  String? debugging;
  String? testing;
  String? trial;
  String? production;

  FormVasBody(
      {this.status,
      this.nomor,
      this.pengerjaan,
      this.diterimaOleh,
      this.disetujuiOleh,
      this.catatan,
      this.wawancara,
      this.konfirmasiDesain,
      this.perancanganDatabase,
      this.pengembanganSoftware,
      this.debugging,
      this.testing,
      this.trial,
      this.production});

  FormVasBody.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    nomor = json['nomor'];
    pengerjaan = json['pengerjaan'];
    diterimaOleh = json['diterimaOleh'];
    disetujuiOleh = json['disetujuiOleh'];
    catatan = json['catatan'];
    wawancara = json['wawancara'];
    konfirmasiDesain = json['konfirmasiDesain'];
    perancanganDatabase = json['perancanganDatabase'];
    pengembanganSoftware = json['pengembanganSoftware'];
    debugging = json['debugging'];
    testing = json['testing'];
    trial = json['trial'];
    production = json['production'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['nomor'] = this.nomor;
    data['pengerjaan'] = this.pengerjaan;
    data['diterimaOleh'] = this.diterimaOleh;
    data['disetujuiOleh'] = this.disetujuiOleh;
    data['catatan'] = this.catatan;
    data['wawancara'] = this.wawancara;
    data['konfirmasiDesain'] = this.konfirmasiDesain;
    data['perancanganDatabase'] = this.perancanganDatabase;
    data['pengembanganSoftware'] = this.pengembanganSoftware;
    data['debugging'] = this.debugging;
    data['testing'] = this.testing;
    data['trial'] = this.trial;
    data['production'] = this.production;
    return data;
  }
}

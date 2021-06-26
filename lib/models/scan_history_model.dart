import 'dart:typed_data';

class ScanHistoryModel {
  int? id;
  String? text;
  Uint8List? photo;

  ScanHistoryModel(this.text, this.photo);
  ScanHistoryModel.withId(this.id, this.text, this.photo);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
    map['photo'] = photo;

    return map;
  }

  ScanHistoryModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    photo = map['photo'];
  }
}

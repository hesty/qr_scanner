import 'dart:typed_data';

class GenerateHistoryModel {
  int id;
  String type;
  String text;
  Uint8List photo;

  GenerateHistoryModel(this.type, this.text, this.photo);
  GenerateHistoryModel.withId(this.id, this.type, this.text, this.photo);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['type'] = type;
    map['text'] = text;
    map['photo'] = photo;

    return map;
  }

  GenerateHistoryModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.type = map['type'];
    this.text = map['text'];
    this.photo = map['photo'];
  }
}

import 'package:psychonauts_app/models/PsiPower.dart';

class Character {
  String gender = '';
  String img = '';
  String sId = '';
  String name = '';
  List<PsiPower> psiPowers = [];
  int iV = 0;

  Character({required this.gender, required this.img, required this.sId, required this.name, required this.psiPowers, required this.iV});

  Character.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    img = json['img'];
    sId = json['_id'];
    name = json['name'];
    if (json['psiPowers'] != null) {
      psiPowers = <PsiPower>[];
      json['psiPowers'].forEach((v) {
        psiPowers.add(PsiPower.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['img'] = this.img;
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.psiPowers != null) {
      data['psiPowers'] = this.psiPowers.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}


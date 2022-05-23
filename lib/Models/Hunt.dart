import 'dart:convert';

import 'package:quarantine_dex/Models/Pokemon.dart';
import 'package:quarantine_dex/tools/util.dart';

class Hunt {

  int     id;
  int     trackingId;
  Pokemon pkmn;
  Method  method;
  Dex     dex;
  bool    charm;
  int     encounters;

  Hunt({
    this.id,
    this.trackingId,
    this.pkmn,
    this.method,
    this.dex,
    this.charm,
    this.encounters
  });

  Map<String, dynamic> toMap() {
    return {
      'id'          : id,
      'tracking_id' : trackingId,
      'pkmn'        : jsonEncode(pkmn.toMap()),
      'method'      : method.index,
      'dex'         : dex.index,
      'charm'       : charm ? 1 : 0,
      'encounters'  : encounters
    };
  }

  Hunt.fromMap(Map<String, dynamic> map) {
    id          = map['id'];
    trackingId  = map['tracking_id'];
    pkmn        = Pokemon.fromMap(jsonDecode(map['pkmn']));
    method      = methodFromIndex(map['method']);
    dex         = dexFromIndex(map['dex']);
    charm       = map['charm'] == 1;
    encounters  = map['encounters'];
  }

  String encode(Pokemon data) {
    print("Encode payload: " + data.toString());
    return data.toString();
  }

  Pokemon decode(String data) {

  }

}
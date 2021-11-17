import 'package:quarantine_dex/tools/util.dart';

// Stores info about different active dexes
// TODO add support for different dex types

class DexHeader {
  int     id;
  Dex     dex;
  String  name;
  bool    shiny;
  bool    forms;

  DexHeader({
    this.id,
    this.dex,
    this.name,
    this.shiny,
    this.forms
  });

  Map<String, dynamic> toMap() {
    return {
      'id'    : id,
      'dex'   : dex.index,
      'name'  : name,
      'shiny' : shiny ? 1 : 0,
      'forms' : forms ? 1 : 0
    };
  }

  DexHeader.fromMap(Map<String, dynamic> map) {
    this.id     = map['id'];
    this.dex    = dexFromIndex(map['dex']);
    this.name   = map['name'];
    this.shiny  = map['shiny'] == 1;
    this.forms  = map['forms'] == 1;
  }
}
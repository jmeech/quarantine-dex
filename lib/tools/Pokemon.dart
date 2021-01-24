class Pokemon {
  String name;
  int id;
  int dexNum;
  List<int> types;

  Pokemon({
    this.name,
    this.id,
    this.dexNum,
    this.types
  });

  /*
  Map<String, dynamic> toMap() {
    return {
      'name'    : name,
      'id'      : id,
      'dexNum'  : dexNum,
      'types'   : types
    };
  }
  */

  Pokemon.fromMap(Map<String, dynamic> map) {
    this.name   = map['name'];
    this.id     = map['id'];
    this.dexNum = map['dexNum'];
    this.types  = [map['slot_1'], map['slot_2']];
  }

}
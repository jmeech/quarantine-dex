class Pokemon {
  String name;
  String form;
  int id;
  int dexNum;
  List<int> types;

  Pokemon({
    this.name,
    this.form,
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
    this.form   = map['form'];
    this.id     = map['id'];
    this.dexNum = map['dexNum'];
    this.types  = [map['type_1'], map['type_2']];
  }

}
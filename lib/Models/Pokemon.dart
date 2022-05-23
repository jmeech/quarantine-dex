/**
 * Stores info about a particular Pokemon in the dex
 *
 * @param     name    The name of the Pokemon
 * @param     form    The name of the particular form, if applicable
 * @param     id      The unique ID of the particular Pokemon/form
 * @param     dexNum  The Pokemon's number in the particular dex being tracked
 * @param     types   The types of the given Pokemon
 */
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

  /**
   * Converts the map received from the DB to a Pokemon object
   *
   * @param   map   A map representation of the Pokemon object
   * @return        The Pokemon object represented by the map
   */
  Pokemon.fromMap(Map<String, dynamic> map) {
    this.name   = map['name'];
    this.form   = map['form'];
    this.id     = map['id'];
    this.dexNum = map['dexNum'];
    this.types  = [map['type_1'], map['type_2']];
  }

  Map<String, dynamic> toMap() {
    return {
      'name'    : name,
      'form'    : form,
      'id'      : id,
      'dexNum'  : dexNum,
      'types'   : types
    };
  }
}
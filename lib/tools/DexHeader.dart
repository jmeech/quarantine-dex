import 'package:quarantine_dex/tools/util.dart';

/**
 * Stores info about a particular tracked dex
 *
 * @param   id      An ID number for access
 * @param   dex     The particular dex type being tracked
 * @param   name    The name given to the dex being tracked
 * @param   shiny   Indicates whether the dex is shiny or regular
 * @param   forms   Indicates whether the dex tracks base forms or all forms
 * @param   data    The full list of stored Pokemon
 */
class DexHeader {
  int       id;
  Dex       dex;
  String    name;
  bool      shiny;
  bool      forms;
  List<int> data;

  DexHeader({
    this.id,
    this.dex,
    this.name,
    this.shiny,
    this.forms,
    this.data
  });

  /**
   * Converts the DexHeader object to a map to write to DB
   *
   * @return    A map representation of the DexHeader object
   */
  Map<String, dynamic> toMap() {
    return {
      'id'    : id,
      'dex'   : dex.index,
      'name'  : name,
      'shiny' : shiny ? 1 : 0,
      'forms' : forms ? 1 : 0,
      'data'  : encode(data),
    };
  }

  /**
   * Converts the map received from the DB to a DexHeader object
   *
   * @param   map   A map representation of the DexHeader object
   * @return        The DexHeader object represented by the map
   */
  DexHeader.fromMap(Map<String, dynamic> map) {
    id     = map['id'];
    dex    = dexFromIndex(map['dex']);
    name   = map['name'];
    shiny  = map['shiny'] == 1;
    forms  = map['forms'] == 1;
    data   = decode(map['data']);
  }

  /**
   * Encodes the data payload to a string for saving to the DB.
   *
   * @param   data    The list of ints to be encoded
   * @return          The list represented as a string
   */
  String encode(List<dynamic> data) {
    print("Encode payload: " + data.toString());
    return data.toString();
  }

  /**
   * Decodes the string payload to rebuild a DexHeader element.
   *
   * @param   data    The string representation of the int list
   * @return          The list of ints to be stored
   */
  List<int> decode(String data) {

    // Trim brackets from string and parse
    data = data.substring(1, data.length - 1);
    List<String> dataParsed = data.split(',');
    List<int> ret = [];
    dataParsed.forEach((String e) {
      int val = int.tryParse(e);
      if(val != null) ret.add(val);
    });

    print("Decoded: " + ret.toString());
    return ret;
  }
}
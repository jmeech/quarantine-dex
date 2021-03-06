import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quarantine_dex/tools/DexHeader.dart';
import 'package:quarantine_dex/tools/Pokemon.dart';
import 'package:quarantine_dex/tools/util.dart';
import 'package:sqflite/sqflite.dart';

class AppDB {

  // Set up AppDB as singleton
  AppDB._();
  static final AppDB _instance = AppDB._();

  // Allow outside access
  factory AppDB() {
    return _instance;
  }

  // used to access non DB files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }


  Future<File> _localFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = await directory.path;
    return File('$path/$filename');
  }

  // Provide single point of entry to DB
  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  // Initialize DB
  initDB() async {

    // construct path
    var _dbPath = await getDatabasesPath();
    var _path = join(_dbPath, "app.db");

    var exists = await databaseExists(_path);
    var debug = false; //true;

    if(!exists || debug) {

      print("No database found, initializing...");

      // Make sure directory exists
      try {
        await Directory(dirname(_path)).create(recursive: true);
      } catch (_) {}

      // delete existing db, easier to make changes
      await deleteDatabase(_path);

      // copy data from asset
      ByteData _data = await rootBundle.load("assets/pkmn_app.db");
      List<int> _bytes = _data.buffer.asUint8List(
          _data.offsetInBytes, _data.lengthInBytes);
      await File(_path).writeAsBytes(_bytes, flush: true);

    } else {
      print("Database found, loading...");
    }
    _db = await openDatabase(_path);
  }

  // ********
  // * READ *
  // ********

  // Read a single pokemon by number
  // TODO create pokemon object and replace
  Future<String> getPkmn(int id) async {

    // final db = await database;
    final List<Map<String, dynamic>> _list = await _db.query(
      'pkmn',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [id]
    );

    return _list[0]['name'];
  }

  // Read the DB for a list of pokemon determined by a given dex order
  Future<List<Pokemon>> getPkmnList(Dex dex) async {

    final List<Map<String, dynamic>> _list = await _db.rawQuery(
      '''
      SELECT
        pkmn.name,
        pkmn.id,
        dex_entries.${dex.sqlColumn} AS dexNum,
        types.slot_1,
        types.slot_2
      FROM
        pkmn
      INNER JOIN
        dex_entries
      ON
        pkmn.id = dex_entries.dex_NAT
      INNER JOIN
        types
      ON
        pkmn.id = types.id
      WHERE
        dexNum IS NOT null
      ORDER BY
        dexNum ASC
      '''
    );

    return List.generate(_list.length, (i) {
      return Pokemon.fromMap(_list[i]);
    });
  }

  Future<List<int>> getTypes(int id) async {
    final List<Map<String, dynamic>> _list = await _db.query(
      'types',
      columns: ['slot_1', 'slot_2'],
      where: 'id = ?',
      whereArgs: [id]
    );
    return [_list[0]['slot_1'], _list[0]['slot_2']];
  }

  // Get the last dex, used to return newly created dexes
  Future<DexHeader> getDexEntry() async {
    final List<Map<String, dynamic>> _list = await _db.rawQuery(
      '''
      SELECT
        *
      FROM
        dex_list
      WHERE
        id=(
          SELECT
            MAX(id)
           FROM
            dex_list
        )
      '''
    );
    return(DexHeader.fromMap(_list.first));
  }

  // Read the list of dexes
  Future<List<DexHeader>> getDexEntryList() async {
    final List<Map<String, dynamic>> dexes = await _db.query('dex_list');

    return List.generate(dexes.length, (i) {
      return DexHeader(
          id:     dexes[i]['id'],
          dex:    dexFromIndex(dexes[i]['dex']),
          name:   dexes[i]['name'],
          shiny:  dexes[i]['shiny'] == 1
      );
    });
  }

  // Gets the list of found pokemon
  Future<List<int>> loadSaved(int id) async {
    final _file = await _localFile('${id.toString()}.txt');

    // If file exists
    if(await _file.exists()) {
      print('Found file');
      String contents = await _file.readAsString();
      print(contents);
      return List<int>.from(JsonDecoder().convert(contents));
    }
    print('Did not find file');
    return List<int>();
  }

  // Writes the list of saved pokemon to storage
  Future<void> writeSaved(int id, List<int> values) async {
    print('Attempting write...');

    final file = await _localFile('${id.toString()}.txt');

    if(! await file.exists()) {
      print('File not found');
      await file.create(recursive: true);
    }

    final objectString = JsonEncoder().convert(values);
    return file.writeAsString(objectString);
  }

  // **********
  // * INSERT *
  // **********

  // Add a new dex to the list of dexes
  Future<DexHeader> addDexEntry(DexHeader _toInsert) async {
    await _db.insert('dex_list', _toInsert.toMap());
    return getDexEntry();
  }

  // **********
  // * DELETE *
  // **********

  Future<List<DexHeader>> deleteDexEntry(int id) async {
    final file = await _localFile('${id.toString()}.txt');
    file.delete();

    await _db.delete(
      'dex_list',
      where: 'id = ?',
      whereArgs: [id]
    );
    return getDexEntryList();
  }

}
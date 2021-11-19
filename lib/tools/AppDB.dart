import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
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

  // Provide single point of entry to DB
  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  // Initialize DB
  Future<dynamic> initDB() async {

    // construct path
    var _dbPath = await getDatabasesPath();
    var _path = join(_dbPath, "app.db");

    var debug = false;

    if(debug) {
      await ((await openDatabase(_path)).close());
      await deleteDatabase(_path);
    }

    var exists = await databaseExists(_path);

    if(!exists) {

      print("No database found, initializing...");

      // Make sure directory exists
      try {
        await Directory(dirname(_path)).create(recursive: true);
      } catch (_) {}


      // delete existing db, easier to make changes
      // await deleteDatabase(_path);

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

  /**
   * Reads the app database for a list of Pokemon determined by a particular dex
   *
   * @param   dex     The dex being returned
   * @param   forms   Whether or not to include alternate forms
   * @param   shiny   Whether or not the desired list should be shiny or not.
   *                  Important when applying exceptions.
   * @return          A list of Pokemon objects
   */
  Future<List<Pokemon>> getPkmnList(Dex dex, bool forms, bool shiny) async {

    // Raw database query
    final List<Map<String, dynamic>> _list = await _db.rawQuery(
      '''
      SELECT
        pkmn.name,
        pkmn.form,
        pkmn.id,
        dex_entries.${dex.sqlColumn} AS dexNum,
        pkmn.type_1,
        pkmn.type_2,
        pkmn.sub
      FROM
        pkmn
      INNER JOIN
        dex_entries
      ON
        ${forms ? "pkmn.species_id" : "pkmn.id"} = dex_entries.dex_NAT
      WHERE
        dexNum IS NOT null
      ORDER BY
        dexNum ASC, pkmn.sub ASC
      '''

    );

    // Programmatically build dex to account for exceptions
    List<Pokemon> _pokedex = [];

    // TODO Exceptions, Spiky-eared pichu, Fairy type Arceus, Gen 7 Minior etc
    _list.forEach((Map pkmn) {
      if (!shiny || !nonShinyAlcremies.contains(pkmn['id']))
        _pokedex.add(Pokemon.fromMap(pkmn));
    });

    return _pokedex;
  }

  /**
   * Returns the list of currently tracked dexes
   * @return    The list of currently tracked dexes
   */
  Future<List<DexHeader>> getAllTracked() async {
    final List<Map<String, dynamic>> dexes = await _db.query('tracking');

    return List.generate(dexes.length, (i) {
      return DexHeader.fromMap(dexes[i]);
    });
  }

  // *********
  // * WRITE *
  // *********

  /**
   * Inserts a new tracked dex to the list of tracked dexes.  Assigns the
   *  dex an ID during the write process.
   *
   * @param   toInsert  The new dex to write to the DB
   * @return            The new dex after being assigned an id
   */
  void addDexEntry(DexHeader _toInsert) async {
    await _db.insert(
        'tracking',
        _toInsert.toMap()
    );
  }

  /**
   * Update an existing tracked dex in the list of tracked dexes.
   *
   * @param   toUpdate  The dex to be updated
   * @return            The updated Dex
   */
  void updateDexEntry(DexHeader _toUpdate) async {
    await _db.update(
        'tracking',
        _toUpdate.toMap(),
        where: 'id = ?',
        whereArgs: [_toUpdate.id]
    );
  }

  // **********
  // * DELETE *
  // **********

  /**
   * Removes a tracked dex from the list of tracked dexes.
   *
   * @param   id  The ID of the tracked dex to be deleted
   * @return      The new list of tracked dexes
   */
  void deleteDexEntry(int id) async {
    await _db.delete(
        'tracking',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  // *********
  // * DEBUG *
  // *********

}
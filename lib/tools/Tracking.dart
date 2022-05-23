import 'package:quarantine_dex/Models/DexHeader.dart';
import 'package:quarantine_dex/Models/Hunt.dart';
import 'package:quarantine_dex/tools/AppDB.dart';

class Tracking {

  // *********
  // * SETUP *
  // *********

  List<DexHeader> saved = [];
  List<Hunt>      hunts = [];

  // Set up Tracking class as singleton
  Tracking._({
    this.saved,
    this.hunts
  });

  static final Tracking _instance = Tracking._();

  // Allow outside access
  factory Tracking() {
    return _instance;
  }

  // Initialize Dex list
  init() async {
    AppDB().getAllDexes().then((result) {
      this.saved = result;
    });

    AppDB().getAllHunts().then((result) {
      this.hunts = result;
    });
  }

  // ******************
  // * SAVE FUNCTIONS *
  // ******************

  /**
   * Saves the given dex to the tracking list.  Generates an ID for the
   * given dex if it hasn't been given one yet.  Adds the given dex to
   * the list if it doesn't exist yet, updates the existing one if it does.
   * @param   save    The dex to be saved
   * @return          The saved dex with it's new ID if applicable
   */
  DexHeader saveDex(DexHeader save) {
    // If new dex
    if(save.id == null) {
      // Get new ID
      if(saved != null && saved.isNotEmpty) {
        saved.sort((a, b) => a.id.compareTo(b.id));
        save.id = saved.last.id + 1;
      }
      else {
        save.id = 0;
      }
      saved.add(save);
      AppDB().addDex(save);
    }
    else {
      saved[saved.indexWhere((e) => e.id == save.id)] = save;
      AppDB().updateDex(save);
    }
    return save;
  }

  Hunt saveHunt(Hunt save) {
    // If new dex
    if(save.id == null) {
      // Get new ID
      if(hunts != null && hunts.isNotEmpty) {
        hunts.sort((a, b) => a.id.compareTo(b.id));
        save.id = hunts.last.id + 1;
      }
      else {
        save.id = 0;
      }
      hunts.add(save);
      AppDB().addHunt(save);
    }
    else {
      hunts[hunts.indexWhere((e) => e.id == save.id)] = save;
      AppDB().updateHunt(save);
    }
    return save;
  }


  // ******************
  // * LOAD FUNCTIONS *
  // ******************

  /**
   * Requests a dex by ID number and returns it.
   * @param   id    The id of the requested dex
   * @return        The requested dex
   */
  DexHeader loadDex(int id) {
    return saved.firstWhere((e) => e.id == id);
  }

  Hunt loadHunt(int id) {
    return hunts.firstWhere((e) => e.id == id);
  }

  List<Hunt> loadHuntsByDex(int id) {
    List<Hunt> toReturn = [];
    hunts.forEach((e) {
      if(e.trackingId == id) toReturn.add(e);
    });
    return toReturn;
  }

  // ********************
  // * UPDATE FUNCTIONS *
  // ********************



  // ********************
  // * DELETE FUNCTIONS *
  // ********************

  /**
   * Deletes a dex from the list by ID number.
   * @param   id    The ID of the dex to delete
   */
  void deleteDex(int id) {
    saved.removeAt(saved.indexWhere((e) => e.id == id));
    AppDB().deleteDex(id);
  }

  void deleteHunt(int id) {
    hunts.removeAt(hunts.indexWhere((e) => e.id == id));
    AppDB().deleteHunt(id);
  }

  // *********************
  // * UTILITY FUNCTIONS *
  // *********************

  /**
   * Returns true if the dex list is empty or uninitialized.
   */
  bool get isEmpty {
    return saved == null || saved.isEmpty;
  }

  /**
   * Returns the number of items in the dex list.
   */
  int get length {
    return saved.length;
  }

  int huntsCount() {
    return hunts.length;
}

  /**
   * Returns the dex list item at index i.  This should be
   * used for iterating over the full list, not for accessing
   * elements as index i is not necessarily the item's ID.
   */
  operator [](int i) => saved[i];

}
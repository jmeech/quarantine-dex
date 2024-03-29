import 'package:flutter/material.dart';
import 'package:quarantine_dex/Models/Hunt.dart';
import 'package:quarantine_dex/Models/Odds.dart';
import 'package:quarantine_dex/Models/Pokemon.dart';
import 'package:quarantine_dex/tools/Tracking.dart';

class ShinyTracker extends StatefulWidget {

  final Hunt    hunt;

  ShinyTracker(
    this.hunt,
  );

  @override
  _ShinyTrackerState createState() => _ShinyTrackerState();
}

class _ShinyTrackerState extends State<ShinyTracker> {

  Pokemon _pkmn;
  Hunt    _hunt;
  Odds    _odds;
  bool    _found;

  @override
  void initState() {
    super.initState();
    _hunt = widget.hunt;
    _pkmn = _hunt.pkmn;
    _odds = new Odds(
      _hunt.method,
      _hunt.charm,
      _determineOdds()
    );
    _found = false;
    _odds.setEncounters(_hunt.encounters);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _hunt.encounters = _odds.count;
        print(_hunt.toMap().toString());
        Tracking().saveHunt(_hunt);
        Navigator.of(context).pop(false);
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text("Currently Hunting"),
        ),

        body: Column(
          children: [

            // Sprite/clickable
            Expanded (
              child: InkWell(
                child: Container(
                  child: Image(
                    image: AssetImage(getSpritePath(_pkmn.id, true)),
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.fitWidth,
                  )
                ),
                onTap: () {
                  setState(() {
                    _odds.encounter();
                  });
                },
              ),
            ),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _generateDataWidget("Odds:", _odds.formatOdds()),
                    _generateDataWidget("Cumulative:", _odds.formatCumulative()),
                    _generateDataWidget("Encounters", _odds.count.toString()),
                  ],

                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    _generateDataWidget("Estimate:", _odds.formatEstimate()),
                    _generateDataWidget("Percent:", _odds.formatPercent()),
                  ]
                )
              ],
            ),

            //Found
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _foundHandler,
                  child: Text("Found!"),
                )
              ],
            )
          ],
        )
      )
    );
  }

  Widget _generateDataWidget(String label, var data) {
    return new Column(
        children: <Widget> [
          new Text(
            label,
          ),
          new Text(
            data,
          )
        ]
    );
  }

    Future<void> _foundHandler() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Pokemon to dex?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _found = true;
                    Navigator.of(context).pop();
                  },
                  child: Text("Add"),
                ),
              ]
            )
          )
        );
      }
    ).then((value) {
      if(_found) { Navigator.of(context).pop(_found); };
    });
  }

  num _determineOdds() {
    return (_hunt.dex.index < 10) ? 4096 : 8192;
  }

  String getSpritePath(int id, bool shiny) {
    String folder = shiny ? 'shiny_sprites' : 'normal_sprites';
    String filename = '${id.toString()}.png'.replaceAll("^0+", "");
    return 'assets/$folder/$filename';
  }
}
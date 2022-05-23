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
    _odds.setEncounters(_hunt.encounters);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        _hunt.encounters = _odds.count;
        print(_hunt.toMap().toString());
        Tracking().saveHunt(_hunt);
        return true;
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text("Currently Hunting"),
        ),

        body: Column(
          children: [
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

  num _determineOdds() {
    return (_hunt.dex.index < 10) ? 4096 : 8192;
  }

  String getSpritePath(int id, bool shiny) {
    String folder = shiny ? 'shiny_sprites' : 'normal_sprites';
    String filename = '${id.toString()}.png'.replaceAll("^0+", "");
    return 'assets/$folder/$filename';
  }
}
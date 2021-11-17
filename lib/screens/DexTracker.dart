import 'package:flutter/material.dart';
import 'package:quarantine_dex/tools/util.dart';
import 'package:quarantine_dex/tools/AppDB.dart';
import 'package:quarantine_dex/tools/Pokemon.dart';
import 'package:quarantine_dex/tools/DexHeader.dart';

class DexTracker extends StatefulWidget {

  DexHeader header;

  DexTracker(
    this.header,
  );

  @override
  _DexTrackerState createState() => _DexTrackerState();
}

class _DexTrackerState extends State<DexTracker> {

  double        _percentComplete = 0;
  DexHeader     _header;
  List<Pokemon> _pokedex    = [];
  List<int>     _savedPkmn  = [];

  @override
  void initState() {
    super.initState();

    _header = widget.header;

    AppDB().getPkmnList(_header.dex, _header.forms, _header.shiny).then((value) {
      setState(() {
        _pokedex = value;
      });
    });

    AppDB().loadSaved(_header.id).then((values) {
      setState(() {
        _savedPkmn.addAll(values);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    _percentComplete = _pokedex.length != 0 ? _savedPkmn.length / _pokedex.length : 0;

    return WillPopScope(
      onWillPop: () async {
        AppDB().writeSaved(_header.id, _savedPkmn);
        return true;
      },
      child: Scaffold(

        appBar: AppBar(
          title: Text(_header.name),
        ),

        body: Column(

          children: [

            Text(
              '${(_percentComplete * 100).round()}% complete',
            ),

            // Visualize percent complete
            LinearProgressIndicator(
              value: _percentComplete,
            ),

            // Dex Grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(3.0),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: _pokedex != null ? _pokedex.length : 0,
                itemBuilder: (context, i) {
                  return _buildPanel(_pokedex[i]);
                }
              ),
            ),
          ]
        ),
      ),
    );
  }

  // Generate single dex entry
  Widget _buildPanel(Pokemon pokemon) {

    bool saved = _savedPkmn.contains(pokemon.id);

    // Panel
    Container panel = new Container(
      padding: new EdgeInsets.all(3.0),

      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: (saved ?
                LinearGradient(
                  colors: [
                    typeColors[pokemon.types[0]],
                    typeColors[pokemon.types[1] != null ? pokemon.types[1] : pokemon.types[0]]
                  ],
                  stops: [0.3, 0.7],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) :
                null
              ),

            ),
          ),

          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(255, 255, 255, .45),
                  Color.fromRGBO(255, 255, 255, 0)
                ],
                stops: [0.25, 1],
              ),
              border: Border.all(
                color: Colors.black87,
                width: saved ? 1.1 : .9,
              ),
            ),

            child: Stack(
              children: [

                // Label
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    color: Color.fromRGBO(255, 255, 255, .66),
                    child: Text(
                      '#' + pokemon.dexNum.toString().padLeft(3, "0"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                //Expanded(
                  /*child: */Container(
                    child: Image(
                      image: AssetImage(getSpritePath(pokemon.id, _header.shiny)),
                    ),
                    alignment: Alignment.center,
                  ),
                //),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    color: Color.fromRGBO(255, 255, 255, .5),
                    child: Text(
                      pokemon.name + (pokemon.form != null ? "\n" + pokemon.form : ""),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Allows interactivity
    return GestureDetector(
      onTap: () {
        setState(() {
          if (saved) {
            _savedPkmn.remove(pokemon.id);
          } else {
            _savedPkmn.add(pokemon.id);
          }
          _percentComplete = _savedPkmn.length / _pokedex.length;
        });
      },
      onLongPress: () {
        setState(() {
          // TODO information popup
        });
      },
      child: panel,
    );
  }

  String getSpritePath(int id, bool shiny) {
    String folder = shiny ? 'shiny_sprites' : 'normal_sprites';
    String filename = '${id.toString()}.png'.replaceAll("^0+", "");
    return 'assets/$folder/$filename';
  }
}

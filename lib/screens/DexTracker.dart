import 'package:flutter/material.dart';
import 'package:quarantine_dex/tools/util.dart';
import 'package:quarantine_dex/tools/AppDB.dart';
import 'package:quarantine_dex/tools/Pokemon.dart';
import 'package:quarantine_dex/tools/DexHeader.dart';

class DexTracker extends StatefulWidget {

  final DexHeader header;

  DexTracker(
    this.header,
  );

  @override
  _DexTrackerState createState() => _DexTrackerState();
}

class _DexTrackerState extends State<DexTracker> {

  double        _percentComplete = 0;
  DexHeader     _header;
  List<Pokemon> _pokedex      = [];
  List<int>     _savedPkmn    = [];
  List<Pokemon> _filterList   = [];

  @override
  void initState() {
    super.initState();

    _header = widget.header;

    AppDB().getPkmnList(_header.dex, _header.forms, _header.shiny).then((value) {
      setState(() {
        _pokedex = value;
        _savedPkmn.addAll(_header.data);
        _filterList.addAll(_pokedex);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    // Calculate completion
    _percentComplete = _pokedex.length != 0 ? _savedPkmn.length / _pokedex.length : 0;

    // Will pop scope allows auto write when the page is navigated from
    return WillPopScope(
      onWillPop: () async {
        _header.data = _savedPkmn;
        await AppDB().updateDexEntry(_header);
        return true;
      },
      child: Scaffold(

        // Top bar
        appBar: AppBar(
          title: Text(_header.name),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: themeColor,
          onPressed: () {
            print("clicked");
            showModalBottomSheet(context: context, builder: (context) => (
                Container(
                  margin: EdgeInsets.all(4),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      counter: Offstage(),
                    ),
                    maxLength: 12,
                    onChanged: (String _filter) {
                      setState(() {
                        if(_filter.isEmpty || _filter == "") {
                          _filterList.clear();
                          _filterList.addAll(_pokedex);
                        }
                        else {
                          _filterList.clear();
                          _pokedex.forEach((e) {
                            if(e.name.toLowerCase().contains(_filter)) _filterList.add(e);
                          });
                        }
                      });
                    },
                  ),
                )
            ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3)
                ),
              ),
            );
          },
          tooltip: 'Filter pokemon...',
          child: Icon(Icons.search),
        ),

        // Main content
        body: Column(

          children: [

            // Percentage tracker
            Text(
              '${(_percentComplete * 100).floor()}% complete',
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
                itemCount: _filterList != null ? _filterList.length : 0,
                itemBuilder: (context, i) {
                  return _buildPanel(_filterList[i]);
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

          // Main container gradient.  Must be first to show up behind all other elements
          Container(
            decoration: BoxDecoration(
              gradient: (saved ?
                LinearGradient(
                  colors: [
                    typeColors[pokemon.types[0]],
                    typeColors[pokemon.types[1] != null ?
                      pokemon.types[1] : pokemon.types[0]]
                  ],
                  stops: [0.3, 0.7],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) :
                null
              ),

            ),
          ),

          // Main container outline
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

                // Sprite
                Container(
                  child: Image(
                    image: AssetImage(getSpritePath(pokemon.id, _header.shiny)),
                  ),
                  alignment: Alignment.center,
                ),

                // Name
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    color: Color.fromRGBO(255, 255, 255, .5),
                    child: Text(
                      _header.forms ?
                        // If form dex
                        pokemon.name + (pokemon.form != null ? "\n" + pokemon.form : "")
                      :
                        // Otherwise
                        pokemon.name,
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

  /**
   * Returns the proper sprite for the given Pokemon
   *
   * @param   id      The unique ID for the particular pokemon
   * @param   shiny   Whether or not it's looking for the base or shiny
   * @return  The formatted sprite path
   */
  String getSpritePath(int id, bool shiny) {
    String folder = shiny ? 'shiny_sprites' : 'normal_sprites';
    String filename = '${id.toString()}.png'.replaceAll("^0+", "");
    return 'assets/$folder/$filename';
  }
}

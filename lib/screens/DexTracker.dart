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

class _DexTrackerState extends State<DexTracker> with TickerProviderStateMixin {

  double        _percentComplete = 0;
  DexHeader     _header;
  String        _filterValue  = "";
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
            _buildSearchModal();
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
              child: _buildGrid(),
            ),
          ]
        ),
      ),
    );
  }

  /**
   * Builds the containing grid for the Dex Tracker elements to sit in
   *
   * @return    A GridView containing the individual Pokemon panels
   */
  Widget _buildGrid() {
    return GridView.builder(
        padding: EdgeInsets.all(3),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _filterList != null ? _filterList.length : 0,
        itemBuilder: (context, i) {
          return _buildPanel(_filterList[i]);
        });
  }

  /**
   * Builds a panel displaying a particular pokemon's information
   *
   * @param   pkmn    The Pokemon object to be rendered
   * @return          The rendered panel containing the pokemon's information
   */
  Widget _buildPanel(Pokemon pkmn) {

    bool saved = _savedPkmn.contains(pkmn.id);
    return Card(
      elevation: 2,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,

      child: InkWell(
        child: Stack(
          children: [

            AnimatedOpacity(
              opacity: saved ? 1 : 0,
              duration: Duration(milliseconds: 150),
              child: Container(
                decoration: BoxDecoration(
                  gradient: (LinearGradient(
                      colors: [
                        typeColors[pkmn.types[0]],
                        typeColors[pkmn.types[1] != null ?
                        pkmn.types[1] : pkmn.types[0]]
                      ],
                      stops: [0.3, 0.7],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  ),
                ),
              ),
            ),

            // Label
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                color: Color.fromRGBO(255, 255, 255, .66),
                child: Text(
                  '#' + pkmn.dexNum.toString().padLeft(3, "0"),
                  textAlign: TextAlign.center,
                ),
              ),
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
                  pkmn.name + (pkmn.form != null ? "\n" + pkmn.form : "")
                      :
                  // Otherwise
                  pkmn.name,
                  textAlign: TextAlign.center,
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
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            Container(
              child: Image(
                image: AssetImage(getSpritePath(pkmn.id, _header.shiny)),
              ),
              alignment: Alignment.center,
            )
          ]
        ),
        onTap: () {
          setState(() {
            if (saved) {
              _savedPkmn.remove(pkmn.id);
            } else {
              _savedPkmn.add(pkmn.id);
            }
            _percentComplete = _savedPkmn.length / _pokedex.length;
          });
        },
        onLongPress: () {
          setState(() {
            // TODO information popup
          });
        },
      ),
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

  void _buildSearchModal() {
    TextEditingController _txt;
    _txt      = TextEditingController();
    _txt.text = _filterValue;
    _txt.selection = TextSelection.fromPosition(TextPosition(offset: _filterValue.length));

    showModalBottomSheet(context: context, builder: (context) => (
        Container(
          margin: EdgeInsets.all(4),
          // Keeps the modal over the keyboard
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
          ),

          child: TextField(
            autofocus: true,
            controller: _txt,
            decoration: InputDecoration(
              hintText: 'Filter dex...',
              counter: Offstage(),
            ),
            maxLength: 12,

            onChanged: (String _filter) {
              _filterValue = _filter;
              setState(() {
                if(_filterValue.isEmpty || _filterValue == "") {
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
      isScrollControlled: true,

    );
  }
}

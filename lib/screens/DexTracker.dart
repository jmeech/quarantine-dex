import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quarantine_dex/Models/Hunt.dart';
import 'package:quarantine_dex/tools/Tracking.dart';
import 'package:quarantine_dex/tools/util.dart';
import 'package:quarantine_dex/tools/AppDB.dart';
import 'package:quarantine_dex/Models/Pokemon.dart';
import 'package:quarantine_dex/Models/DexHeader.dart';

import 'ShinyTracker.dart';

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
  List<Hunt>    _huntList     = [];

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
      _huntList = Tracking().loadHuntsByDex(_header.id);
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
        await AppDB().updateDex(_header);
        return true;
      },

      child: DefaultTabController(
        length: 2,
        child: Scaffold(

          // Top bar
          appBar: AppBar(
            title: Text(_header.name),
            bottom: TabBar(
              indicatorColor: Colors.black87,
              tabs: [
                Tab(text: 'Dex tracker'),
                Tab(text: "Shiny hunts"),
              ]
            ),
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
          body: TabBarView(
            children: [
              Column(

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

              ListView.builder(
                itemCount: _huntList.length,
                itemBuilder: (context, i) {

                  Hunt _data = _huntList[i];

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(_data.pkmn.name),
                      subtitle: Text(
                        "id: " + _data.id.toString() +
                        " Count: " + _data.encounters.toString()
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          return showDialog<void>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            Tracking().deleteHunt(_data.id);
                                            _huntList = Tracking().loadHuntsByDex(_header.id);
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShinyTracker(
                            _data,
                          ))
                        ).then((value) {
                          setState(() {});
                        });
                      }
                    ),
                  );
                },
              )
            ],
          ),
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
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(getSpritePath(pkmn.id, _header.shiny))
                )
              )
              //child: Image(
              //  image: AssetImage(getSpritePath(pkmn.id, _header.shiny)),
              //),
              //alignment: Alignment.center,
            )
          ]
        ),
        enableFeedback: true,
        onTap: () {
          HapticFeedback.heavyImpact();
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

          Hunt _toOpen = Tracking().hunts.firstWhere(
            (e) => e.pkmn.id == pkmn.id,
            orElse: () {
              return Hunt(
                id: null,
                trackingId: _header.id,
                pkmn: pkmn,
                method: Method.FULL,
                dex: _header.dex,
                charm: false,
                encounters: 0
              );
            }
          );

          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShinyTracker(
                Tracking().saveHunt(_toOpen)
              ))
            ).then((value) {
              _huntList = Tracking().loadHuntsByDex(_header.id);
              setState(() {});
            });
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

import "package:flutter/material.dart";
import 'package:quarantine_dex/screens/DexSetup.dart';
import 'package:quarantine_dex/screens/DexTracker.dart';
import 'package:quarantine_dex/tools/util.dart';
import "package:quarantine_dex/tools/AppDB.dart";
import "package:quarantine_dex/tools/DexHeader.dart";

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // Get list of active dexes from AppDB
  // ID number corresponds with txt file to store caught mons
  List<DexHeader> _dexList = [];
  String _testingName = "Create a new dex to track!";

  @override
  void initState() {
    super.initState();
    // Nested to avoid reading an unpopulated DB,
    // With any luck find a more elegant solution
    AppDB().initDB().then((test) {
      _refreshDexList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // Side bar
      drawer: Drawer(
        child: ListView(
          children: [

            Container(
              height: 100,
              child: DrawerHeader(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.withAlpha(120),
                        Colors.teal.withAlpha(150)
                      ],
                      stops: [0.1, 0.9],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/drawer.jpg'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.settings
              ),
              title: Text("Settings..."),
              onTap: () {
                AppDB().testDB();
              }
            ),

            ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: Text("About..."),
              onTap: () {
                _showAbout();
              },
            ),
          ],
        )
      ),

      // Main body
      body: _dexList.isEmpty ?

        // Content if dex list is empty
        Text(_testingName)
      :
        // Content if dex list is not empty
        ListView.builder(
          itemCount: _dexList.length,
          itemBuilder: (context, i) {

            // Get data from header
            int     _dexId    = _dexList[i].id;
            Dex     _dex      = _dexList[i].dex;
            String  _dexName  = _dexList[i].name;
            bool    _shiny    = _dexList[i].shiny;

            return Card(
              child: ListTile(

                // Leading icon based on shiny or not
                // TODO custom icons
                leading:  _shiny ?
                  Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 30,
                  )
                :
                  Icon(
                    Icons.check_box_outlined,
                    color: Colors.black87,
                  ),

                // Name of dex
                title:    Text((i + 1).toString().padLeft(2, '0') + ": " +
                    (_dexName != null ? _dexName : "FIX NULL DEX NAMES")),

                // Dex details
                subtitle: Text(_dex.label + " DEBUG: " + _dexId.toString()),

                // Dex options
                trailing: Row(

                  mainAxisSize: MainAxisSize.min,

                  // Edit dex info
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        /*
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DexEdit(
                            _dexList[i]
                          ))
                        ).then((value) {
                          _refreshDexList();
                        });
                        AppDB().testDB();
                        */
                        _editDex(_dexList[i]);
                      },
                    ),

                    // Delete dex
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        AppDB().deleteDexEntry(_dexList[i].id).then((value) {
                          setState(() {
                            _dexList = value;
                          });
                        });
                      })
                  ],
                ),

                // Open dex on press
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DexTracker(
                      _dexList[i],
                    ))
                  );
                },
              ),
            );
          },
        ),

      // New dex button
      floatingActionButton: FloatingActionButton(
        onPressed: _addDex,
        tooltip: 'Start New Dex',
        child: Icon(Icons.add),
      ),
    );
  }

  // Add a new dex to track
  void _addDex() async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new DexSetup()),
    ).then((value) {
      _refreshDexList();
    });
  }

  // Get dex list and set list
  void _refreshDexList() {
    AppDB().getDexEntryList().then((result) {
      setState(() {
        _dexList = result;
      });
    });
  }

  Future<void> _showAbout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Quarantine Dex'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // TODO add links to credits
                Text("This is a project I started while unemployed on COVID lockdown.  I constantly have several living dexes going at any time across several Pokémon games, and I wanted to have one central place to keep track of them."),
                Text(""),
                Text("All gen 1-5 sprites ripped from Pokémon BW by Veekun"),
                Text("All gen 6 sprites courtesy of Smogon's X/Y Sprite Project"),
                Text("All gen 7 sprites courtesy of Smogon's Sun/Moon Sprite Project"),
                Text("All gen 8 sprites courtesy of Smogon's Sword/Shield Sprite Project"),
                Text(""),
                Text("Please send any suggestions for this app to be3612@gmail.com"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editDex(DexHeader _header) async {

    TextEditingController _txt;
    _txt      = TextEditingController();
    _txt.text = _header.name;
    _txt.selection = TextSelection.fromPosition(TextPosition(offset: _header.name.length));

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
              title: Text("Edit Dex..."),
              content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget> [

                      TextField(
                          maxLength: 40,
                          controller: _txt,
                          onChanged: (String newValue) {
                            setState(() {
                              _header.name = newValue;
                            });
                          }
                      ),

                      Row(
                          children: <Widget> [
                            Container(
                              child: Text(
                                "Shiny Dex?",
                              ),
                              width: 200,
                            ),

                            alignRight(Checkbox(
                                value: _header.shiny,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _header.shiny = newValue;
                                  });
                                }
                            )),
                          ]
                      ),

                      IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            AppDB().updateDexEntry(_header).then((value) {
                              Navigator.of(context).pop();
                              _refreshDexList();
                            });
                          }
                      )
                    ],
                  )
              )
          );
        });
      }
    );
  }
}
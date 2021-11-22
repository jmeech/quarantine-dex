import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quarantine_dex/screens/DexSetup.dart';
import 'package:quarantine_dex/screens/DexTracker.dart';
import 'package:quarantine_dex/tools/Tracking.dart';
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

  String _testingName = "Create a new dex to track!";

  @override
  void initState() {
    super.initState();
    AppDB().initDB().then((value) {
      Tracking().init().then((value) {
        // ¯\_(ツ)_/¯
        Timer(Duration(milliseconds: 5), () {
          setState(() {});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Top Bar
      appBar: AppBar(
        title: Text(widget.title),
      ),

      // Side bar
      drawer: Drawer(
        child: ListView(
          children: [

            // Drawer top image
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

            // Settings tile
            ListTile(
              leading: Icon(
                Icons.settings
              ),
              title: Text("Settings..."),
              onTap: () {
                // TODO settings
              }
            ),

            // About tile
            ListTile(
              leading: Icon(
                Icons.info,
              ),
              title: Text("About..."),
              onTap: () {
                _showAbout();
              },
            ),

            // Debug tile
            ListTile(
              leading: Icon(
                Icons.bug_report_outlined,
              ),
              title: Text("Debug"),
              onTap: () {
                setState(() {});
              },
            ),
          ],
        )
      ),

      // Main body
      body: Tracking().isEmpty ?

        // Content if dex list is empty
        Text(_testingName)

      :
        // Content if dex list is not empty
        ListView.builder(
          itemCount: Tracking().length,
          itemBuilder: (context, i) {

            DexHeader _data = Tracking()[i];

            // Visual card
            return Card(
              elevation: 2,
              child: ListTile(

                // Leading icon based on shiny or not
                // TODO custom icons
                leading:  _data.shiny ?
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
                    (_data.name != null ? _data.name : "FIX NULL DEX NAMES")),

                // Dex details
                subtitle: Text(
                    _data.dex.label +
                    (_data.forms ? " Forms" : " Base") +
                    " DEBUG: " + _data.id.toString()
                ),

                // Dex options
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    // Edit dex info
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editDex(Tracking()[i]);
                      },
                    ),

                    // Delete dex
                    IconButton(
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
                                        Tracking().delete(Tracking()[i].id);
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                      })
                  ],
                ),

                // Open dex on press
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DexTracker(
                      Tracking()[i],
                    ))
                  ).then((value) {
                    //AppDB().getAllTracked().then((result) {
                      setState(() {});
                    //});
                  });
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
      new MaterialPageRoute(
          builder: (context) => new DexSetup()
      ),
    ).then((value) {
      setState(() {});
    });
  }

  // Display info screen
  Future<void> _showAbout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
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
                Text("App Icon courtesy of iconfinder.com icon creator Ramy Wafaa Wadee"),
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

  // Edit an existing dex
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

                      // Dex Name
                      TextField(
                          maxLength: 40,
                          controller: _txt,
                          onChanged: (String newValue) {
                            setState(() {
                              _header.name = newValue;
                            });
                          }
                      ),

                      // Toggle shinyness
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

                      // Toggle forms
                      Row(
                          children: <Widget> [
                            Container(
                              child: Text(
                                "Track forms?",
                              ),
                              width: 200,
                            ),

                            alignRight(Checkbox(
                                value: _header.forms,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _header.forms = newValue;
                                  });
                                }
                            )),
                          ]
                      ),

                      // Confirm
                      IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            Tracking().save(_header);
                            Navigator.of(context).pop();
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
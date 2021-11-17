import "package:flutter/material.dart";
import 'package:quarantine_dex/tools/DexHeader.dart';
import 'package:quarantine_dex/tools/util.dart';
import 'package:quarantine_dex/tools/AppDB.dart';

/*  Edit dex info
 *
 *  Presently just rename and switch shiny or no
 *  Add more options as more are introduced to the app
 */

class DexEdit extends StatefulWidget {

  DexHeader header;

  DexEdit(
    this.header,
  );

  @override
  _DexEditState createState() => _DexEditState();
}

class _DexEditState extends State<DexEdit> {

  DexHeader _header;
  TextEditingController _txt;

  @override
  void initState() {
    super.initState();

    _header = widget.header;
    _txt    = TextEditingController();

    _txt.text = _header.name;
    _txt.selection = TextSelection.fromPosition(TextPosition(offset: _header.name.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Dex..."),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
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
                  Navigator.pop(context);
                });
              }
            )

          ],
        )
      )
    );
  }
}
import "package:flutter/material.dart";
import 'package:quarantine_dex/tools/AppDB.dart';
import 'package:quarantine_dex/tools/DexHeader.dart';
import "package:quarantine_dex/tools/util.dart";
import 'package:quarantine_dex/screens/DexTracker.dart';

class DexSetup extends StatefulWidget {
  DexSetup({Key key}) : super(key: key);

  @override
  _DexSetupState createState() => _DexSetupState();
}

class _DexSetupState extends State<DexSetup> {

  // Default to national dex, default to non shiny dex
  // Default to "New Dex"
  Dex _dexValue = Dex.NATIONAL;
  bool _shiny   = false;
  bool _forms   = false;
  String _name  = "New Dex";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Up Dex"),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [

            TextField(
              decoration: InputDecoration(
                  hintText: 'Name your dex...'
              ),
              maxLength: 40,
              onChanged: (String newValue) {
                setState(() {
                  _name = newValue;
                });
              }
            ),

            DropdownButton<Dex> (
              value: _dexValue,
              items: [
                buildDropdownItem(Dex.NATIONAL),
                buildDropdownItem(Dex.RBY),
                buildDropdownItem(Dex.FRLG),
                buildDropdownItem(Dex.LGPE),
                buildDropdownItem(Dex.GSC),
                buildDropdownItem(Dex.HGSS),
                buildDropdownItem(Dex.RSE),
                buildDropdownItem(Dex.ORAS),
                buildDropdownItem(Dex.DP),
                buildDropdownItem(Dex.PT),
                buildDropdownItem(Dex.BW),
                buildDropdownItem(Dex.B2W2),
                buildDropdownItem(Dex.XY_CENTRAL),
                buildDropdownItem(Dex.XY_COASTAL),
                buildDropdownItem(Dex.XY_MOUNTAIN),
                buildDropdownItem(Dex.SM),
                buildDropdownItem(Dex.SM_MELEMELE),
                buildDropdownItem(Dex.SM_AKALA),
                buildDropdownItem(Dex.SM_ULAULA),
                buildDropdownItem(Dex.SM_PONI),
                buildDropdownItem(Dex.USUM),
                buildDropdownItem(Dex.USUM_MELEMELE),
                buildDropdownItem(Dex.USUM_AKALA),
                buildDropdownItem(Dex.USUM_ULAULA),
                buildDropdownItem(Dex.USUM_PONI),
                buildDropdownItem(Dex.SWSH),
                buildDropdownItem(Dex.IOA),
                buildDropdownItem(Dex.CT),
              ],
              hint: Text("Choose your pokédex..."),
              onChanged: (Dex newValue) {
                setState(() {
                  _dexValue = newValue;
                });
              },
              isExpanded: true,
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
                    value: _shiny,
                    onChanged: (bool newValue) {
                      setState(() {
                        _shiny = newValue;
                      });
                    }
                  )),
                ]
            ),


            Row(
                children: <Widget> [
                  Container(
                    child: Text(
                      "Forms?",
                    ),
                    width: 200,
                  ),

                  alignRight(Checkbox(
                      value: _forms,
                      onChanged: (bool newValue) {
                        setState(() {
                          _forms = newValue;
                        });
                      }
                  )),
                ]
            ),

            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                AppDB().addDexEntry(DexHeader(
                  id: null,
                  dex: _dexValue,
                  name: _name != null ? _name : "",
                  shiny: _shiny,
                  forms: _forms
                )).then((result) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DexTracker(
                      result,
                    ))
                  );
                });
              },
            )

          ]
        )
      )
    );
  }

  Widget buildDropdownItem(Dex value) {
    return DropdownMenuItem<Dex>(
      child: Text(value.label),
      value: value,
    );
  }

}
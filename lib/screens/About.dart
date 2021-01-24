import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Quarantine Dex")
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("App source code written by jmeech"),
          Text("All gen 1-5 Pokémon sprites ripped from Pokemon BW by veekun"),
          Text("https://veekun.com/dex/downloads"),
          Text("All gen 6 Pokémon sprites courtesy of Smogon Gen VI Sprite Project"),
          Text("https://www.smogon.com/forums/threads/x-y-sprite-project.3486712/"),
          Text("All gen 7 Pokémon sprites courtesy of Smogon Sun/Moon Sprite Project"),
          Text("https://www.smogon.com/forums/threads/sun-moon-sprite-project.3577711/"),
          Text("All gen 8 Pokémon sprites courtesy of Smogon Sword/Shield Sprite Project"),
          Text("https://www.smogon.com/forums/threads/sword-shield-sprite-project.3647722/"),

        ]
      )
    );
  }
}
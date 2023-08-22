import 'package:flutter/material.dart';

/// UTILITIES \\\
Widget alignLeft(Widget widget) {
  return Expanded(
      child: Align (
        child: widget,
        alignment: Alignment.centerLeft,
      )
  );
}

Widget alignRight(Widget widget) {
  return Expanded(
      child: Align (
        child: widget,
        alignment: Alignment.centerRight,
      )
  );
}

Widget alignCenter(Widget widget) {
  return Expanded(
      child: Align (
        child: widget,
        alignment: Alignment.center,
      )
  );
}

Widget alignBottom(Widget widget) {
  return Expanded(
      child: Align(
        child: widget,
        alignment: Alignment.bottomCenter,
      )
  );
}

enum Method {
  FULL,
  RESET,
  SAFARI,
  HORDE,
  FISHING,
  RADAR,
  SOS,
  MASUDA,
  BREEDING
}

extension MethodExtension on Method {
  String get label {
    switch (this) {
      case Method.FULL      : return "Full Odds";
      case Method.RESET     : return "Soft Reset";
      case Method.SAFARI    : return "Friend Safari";
      case Method.HORDE     : return "Horde Encounters";
      case Method.FISHING   : return "Chain Fishing";
      case Method.RADAR     : return "Poke Radar";
      case Method.SOS       : return "S.O.S. Encounters";
      case Method.MASUDA    : return "Masuda Method";
      case Method.BREEDING  : return "Breeding";
      default               : return null;
    }
  }
}

Method methodFromIndex(int i) {
  switch(i) {
    case 0 : return Method.FULL;
    case 1 : return Method.RESET;
    case 2 : return Method.SAFARI;
    case 3 : return Method.HORDE;
    case 4 : return Method.FISHING;
    case 5 : return Method.RADAR;
    case 6 : return Method.SOS;
    case 7 : return Method.MASUDA;
    case 8 : return Method.BREEDING;
    default : return null;
  }
}

enum Dex {
  NATIONAL,
  RBY,
  GSC,
  RSE,
  FRLG,
  DP,
  PT,
  HGSS,
  BW,
  B2W2,
  XY_CENTRAL,
  XY_COASTAL,
  XY_MOUNTAIN,
  ORAS,
  SM,
  SM_MELEMELE,
  SM_AKALA,
  SM_ULAULA,
  SM_PONI,
  USUM,
  USUM_MELEMELE,
  USUM_AKALA,
  USUM_ULAULA,
  USUM_PONI,
  LGPE,
  SWSH,
  IOA,
  CT,
  PLA,
  SV
}

extension DexExtension on Dex {
  String get label {
    switch(this) {
      case(Dex.NATIONAL)      : return "National Dex";
      case(Dex.RBY)           : return "Red/Blue/Green/Yellow";
      case(Dex.FRLG)          : return "FireRed/LeafGreen";
      case(Dex.LGPE)          : return "Let's Go, Pikachu/Eevee";
      case(Dex.GSC)           : return "Gold/Silver/Crystal";
      case(Dex.HGSS)          : return "Heart Gold/Soul Silver";
      case(Dex.RSE)           : return "Ruby/Sapphire/Emerald";
      case(Dex.ORAS)          : return "Omega Ruby/Alpha Sapphire";
      case(Dex.DP)            : return "Diamond/Pearl";
      case(Dex.PT)            : return "Platinum";
      case(Dex.BW)            : return "Black/White";
      case(Dex.B2W2)          : return "Black 2/White 2";
      case(Dex.XY_CENTRAL)    : return "XY Central";
      case(Dex.XY_COASTAL)    : return "XY Coastal";
      case(Dex.XY_MOUNTAIN)   : return "XY Mountain";
      case(Dex.SM)            : return "Sun/Moon";
      case(Dex.SM_MELEMELE)   : return "Sun/Moon Melemele Island";
      case(Dex.SM_AKALA)      : return "Sun/Moon Akala Island";
      case(Dex.SM_ULAULA)     : return "Sun/Moon Ula'ula Island";
      case(Dex.SM_PONI)       : return "Sun/Moon Poni Island";
      case(Dex.USUM)          : return "Ultra Sun/Moon";
      case(Dex.USUM_MELEMELE) : return "Ultra Sun/Moon Melemele Island";
      case(Dex.USUM_AKALA)    : return "Ultra Sun/Moon Akala Island";
      case(Dex.USUM_ULAULA)   : return "Ultra Sun/Moon Ula'ula Island";
      case(Dex.USUM_PONI)     : return "Ultra Sun/Moon Poni Island";
      case(Dex.SWSH)          : return "Sword/Shield";
      case(Dex.IOA)           : return "Isle of Armor";
      case(Dex.CT)            : return "Crown Tundra";
      case(Dex.PLA)           : return "Legends: Arceus";
      case(Dex.SV)            : return "Scarlet/Violet";
      default                 : return "UNINITIALIZED DEX";
    }
  }

  String get sqlColumn {
    switch(this) {
      case(Dex.NATIONAL)      : return "dex_NAT";
      case(Dex.RBY)           : return "dex_RBY";
      case(Dex.FRLG)          : return "dex_FRLG";
      case(Dex.LGPE)          : return "dex_LGPE";
      case(Dex.GSC)           : return "dex_GSC";
      case(Dex.HGSS)          : return "dex_HGSS";
      case(Dex.RSE)           : return "dex_RSE";
      case(Dex.ORAS)          : return "dex_ORAS";
      case(Dex.DP)            : return "dex_DP";
      case(Dex.PT)            : return "dex_PT";
      case(Dex.BW)            : return "dex_BW";
      case(Dex.B2W2)          : return "dex_B2W2";
      case(Dex.XY_CENTRAL)    : return "dex_XY_CENTRAL";
      case(Dex.XY_COASTAL)    : return "dex_XY_COASTAL";
      case(Dex.XY_MOUNTAIN)   : return "dex_XY_MOUNTAIN";
      case(Dex.SM)            : return "dex_SM";
      case(Dex.SM_MELEMELE)   : return "dex_SM_MELEMELE";
      case(Dex.SM_AKALA)      : return "dex_SM_AKALA";
      case(Dex.SM_ULAULA)     : return "dex_SM_ULAULA";
      case(Dex.SM_PONI)       : return "dex_SM_PONI";
      case(Dex.USUM)          : return "dex_USUM";
      case(Dex.USUM_MELEMELE) : return "dex_USUM_MELEMELE";
      case(Dex.USUM_AKALA)    : return "dex_USUM_AKALA";
      case(Dex.USUM_ULAULA)   : return "dex_USUM_ULAULA";
      case(Dex.USUM_PONI)     : return "dex_USUM_PONI";
      case(Dex.SWSH)          : return "dex_SWSH";
      case(Dex.IOA)           : return "dex_IOA";
      case(Dex.CT)            : return "dex_CT";
      case(Dex.PLA)           : return "dex_PLA";
      case(Dex.SV)            : return "dex_SV";
      default                 : return "UNINITIALIZED DEX";
    }
  }
}

Dex dexFromIndex(int index) {
  switch(index) {
    case(0)   : return Dex.NATIONAL;
    case(1)   : return Dex.RBY;
    case(2)   : return Dex.GSC;
    case(3)   : return Dex.RSE;
    case(4)   : return Dex.FRLG;
    case(5)   : return Dex.DP;
    case(6)   : return Dex.PT;
    case(7)   : return Dex.HGSS;
    case(8)   : return Dex.BW;
    case(9)   : return Dex.B2W2;
    case(10)  : return Dex.XY_CENTRAL;
    case(11)  : return Dex.XY_COASTAL;
    case(12)  : return Dex.XY_MOUNTAIN;
    case(13)  : return Dex.ORAS;
    case(14)  : return Dex.SM;
    case(15)  : return Dex.SM_MELEMELE;
    case(16)  : return Dex.SM_AKALA;
    case(17)  : return Dex.SM_ULAULA;
    case(18)  : return Dex.SM_PONI;
    case(19)  : return Dex.USUM;
    case(20)  : return Dex.USUM_MELEMELE;
    case(21)  : return Dex.USUM_AKALA;
    case(22)  : return Dex.USUM_ULAULA;
    case(23)  : return Dex.USUM_PONI;
    case(24)  : return Dex.LGPE;
    case(25)  : return Dex.SWSH;
    case(26)  : return Dex.IOA;
    case(27)  : return Dex.CT;
    case(28)  : return Dex.PLA;
    default   : return Dex.NATIONAL;
  }
}

List<int> nonShinyAlcremies = [
  10388,
  10389,
  10390,
  10391,
  10392,
  10393,
  10394,
  10395,
  10396,
  10397,
  10398,
  10399,
  10400,
  10401,
  10402,
  10403,
  10404,
  10405,
  10406,
  10407,
  10408,
  10409,
  10410,
  10411,
  10412,
  10413,
  10414,
  10415,
  10416,
  10417,
  10418,
  10419,
  10420,
  10421,
  10422,
  10423,
  10424,
  10425,
  10426,
  10427,
  10428,
  10429,
  10430,
  10431,
  10432,
  10433,
  10434,
  10435,
  10436,
  10437,
  10438,
  10439,
  10440,
  10441,
  10442,
  10443
];

List<Color> typeColors = [
  Color.fromRGBO(0, 0, 0, 0),
  Color.fromRGBO(168, 167, 122, 1), //normal
  Color.fromRGBO(194, 46, 40, 1),   //fighting
  Color.fromRGBO(169, 143, 243, 1), //flying
  Color.fromRGBO(163, 62, 161, 1),  //poison
  Color.fromRGBO(226, 191, 101, 1), //ground
  Color.fromRGBO(182, 161, 54, 1),  //rock
  Color.fromRGBO(166, 185, 26, 1),  //bug
  Color.fromRGBO(115, 87, 151, 1),  //ghost
  Color.fromRGBO(183, 183, 206, 1), //steel
  Color.fromRGBO(238, 129, 48, 1),  //fire
  Color.fromRGBO(99, 144, 240, 1),  //water
  Color.fromRGBO(122, 199, 76, 1),  //grass
  Color.fromRGBO(247, 208, 44, 1),  //electric
  Color.fromRGBO(249, 85, 135, 1),  //psychic
  Color.fromRGBO(150, 217, 214, 1), //ice
  Color.fromRGBO(111, 53, 252, 1),  //dragon
  Color.fromRGBO(112, 87, 70, 1),   //dark
  Color.fromRGBO(214, 133, 173, 1)  //fairy
];

List<String> types = [
  null,
  "Normal",
  "Fighting",
  "Flying",
  "Poison",
  "Ground",
  "Rock",
  "Bug",
  "Ghost",
  "Steel",
  "Fire",
  "Water",
  "Grass",
  "Electric",
  "Psychic",
  "Ice",
  "Dragon",
  "Dark",
  "Fairy",
];

Map<int, Color> color =
{
  50:Color.fromRGBO(0,  49, 53, .1),
  100:Color.fromRGBO(0, 49, 53, .2),
  200:Color.fromRGBO(0, 49, 53, .3),
  300:Color.fromRGBO(0, 49, 53, .4),
  400:Color.fromRGBO(0, 49, 53, .5),
  500:Color.fromRGBO(0, 49, 53, .6),
  600:Color.fromRGBO(0, 49, 53, .7),
  700:Color.fromRGBO(0, 49, 53, .8),
  800:Color.fromRGBO(0, 49, 53, .9),
  900:Color.fromRGBO(0, 49, 53,  1),
};

MaterialColor themeColor = MaterialColor(0xFF004953, color);


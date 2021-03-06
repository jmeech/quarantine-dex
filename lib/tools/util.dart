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

enum Dex {
  NATIONAL,
  RBY,
  FRLG,
  LGPE,
  GSC,
  HGSS,
  RSE,
  ORAS,
  DP,
  PT,
  BW,
  B2W2,
  XY_CENTRAL,
  XY_COASTAL,
  XY_MOUNTAIN,
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
  SWSH,
  IOA,
  CT
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
      default                 : return "UNINITIALIZED DEX";
    }
  }
}

Dex dexFromIndex(int index) {
  switch(index) {
    case(0)   : return Dex.NATIONAL;
    case(1)   : return Dex.RBY;
    case(2)   : return Dex.FRLG;
    case(3)   : return Dex.LGPE;
    case(4)   : return Dex.GSC;
    case(5)   : return Dex.HGSS;
    case(6)   : return Dex.RSE;
    case(7)   : return Dex.ORAS;
    case(8)   : return Dex.DP;
    case(9)   : return Dex.PT;
    case(10)  : return Dex.BW;
    case(11)  : return Dex.B2W2;
    case(12)  : return Dex.XY_CENTRAL;
    case(13)  : return Dex.XY_COASTAL;
    case(14)  : return Dex.XY_MOUNTAIN;
    case(15)  : return Dex.SM;
    case(16)  : return Dex.SM_MELEMELE;
    case(17)  : return Dex.SM_AKALA;
    case(18)  : return Dex.SM_ULAULA;
    case(19)  : return Dex.SM_PONI;
    case(20)  : return Dex.USUM;
    case(21)  : return Dex.USUM_MELEMELE;
    case(22)  : return Dex.USUM_AKALA;
    case(23)  : return Dex.USUM_ULAULA;
    case(24)  : return Dex.USUM_PONI;
    case(25)  : return Dex.SWSH;
    case(26)  : return Dex.IOA;
    case(27)  : return Dex.CT;
    default   : return Dex.NATIONAL;
  }
}

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
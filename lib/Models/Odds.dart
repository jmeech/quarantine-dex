import 'package:quarantine_dex/tools/util.dart';
import 'dart:math';

class Odds {

  Method method;
  bool   charm;
  num    pulls;
  num    odds;
  num    count;
  num    cumulative;

  Odds(Method methodIn, bool charmIn, num oddsIn) {
    method = methodIn;
    charm  = charmIn;
    odds   = oddsIn;
    pulls  = _setPulls();
    count  = 0;
    cumulative = 0.0;
  }

  void setCharm(bool charm) {
    if(charm != charm) {
      pulls += (charm ? -2 : 2);
      charm = charm;
    }
  }

  double percent() {
    return (cumulative * 100);
  }

  String formatOdds() {
    return pulls.toString() + "/" + odds.toString();
  }

  String formatEstimate() {
    return "1/" + (odds / pulls).floor().toString();
  }

  String formatCumulative() {
    return cumulative.toStringAsFixed(5);
  }

  String formatPercent() {
    return (cumulative * 100).toStringAsFixed(2) + '%';
  }

  void reset() {
    cumulative = 0.0;
    count = 0;
    pulls = (charm ? 3 : 1);
  }

  double encounter() {
    return _iterate();
  }

  double setEncounters(int n) {
    return _calculate(n);
  }

  num _setPulls() {
    num pulls = (charm ? 3 : 1);
    if(method == Method.MASUDA) pulls += 5;
    if(method == Method.SAFARI) pulls += 4;
    return pulls;
  }


  double _iterate() {
    if(count == 0) cumulative = (pulls / odds);
    else {
      switch (method) {
        case Method.FULL     :
        case Method.RESET    :
        case Method.BREEDING :
        case Method.MASUDA   : {
          double temp = (odds - pulls) / odds;
          cumulative += pow(temp, count) * (pulls / odds);
          break;
        }
        case Method.FISHING : {
          pulls += (count <= 20 ? 2 : 0);
          double temp = (odds - pulls) / odds;
          cumulative += pow(temp, count) * (pulls / odds);
          break;
        }
        case Method.SAFARI : {
          double temp = (odds - pulls) / odds;
          cumulative += pow(temp, count) * (pulls / odds);
          break;
        }
        case Method.HORDE : {
          break;
        }
        case Method.RADAR : {
          break;
        }
        case Method.SOS : {
          break;
        }
      }
    }

    ++count;
    return cumulative;
  }

  double _calculate(int n) {
    count = 0;
    while (count < n) {
      _iterate();
    }
    return cumulative;
  }
}
// ignore_for_file: avoid_print

import 'dart:math';

class Chapter01 {
  Chapter01({required this.invoice, required this.plays});

  final Map<String, dynamic> invoice;
  final Map<String, dynamic> plays;

  String statement(Map<String, dynamic> invoice, Map<String, dynamic> plays) {
    var totalAmount = 0.0;
    var volumeCredits = 0;
    var result = 'Statement for ${invoice['customer']}\n';

    for (var perf in invoice['performances']) {
      var play = plays[perf['playID']];
      var thisAmount = amountFor(perf, play);

      // add volume credits
      volumeCredits += max((perf['audience'] as int) - 30, 0);
      // volumeCredits += perf['audience'] as int;
      if (play['type'] == 'comedy') {
        volumeCredits += (perf['audience'] as int) ~/ 5;
      }

      // print line for this order
      result +=
          ' ${play['name']}: \$${(thisAmount / 100).toStringAsFixed(2)} (${perf['audience']} seats)\n';
      totalAmount += thisAmount;
    }

    result += 'Amount owed is \$${(totalAmount / 100).toStringAsFixed(2)}\n';
    result += 'You earned $volumeCredits credits\n';
    return result;
  }

  double amountFor(Map<String, dynamic> perf, Map<String, dynamic> play) {
    var result = 0.0;
    switch (play['type']) {
      case 'tragedy':
        result = 40000;
        if (perf['audience'] > 30) {
          result += 1000 * (perf['audience'] - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (perf['audience'] > 20) {
          result += 10000 + 500 * (perf['audience'] - 20);
        }
        result += 300 * perf['audience'];
        break;
      default:
        throw Exception('Unknown type: ${play['type']}');
    }

    return result;
  }
}

// performance['as-like'] = {'name': 'As You Like It', 'type': 'comedy'};
void main(List<String> args) {
  var invoice = {
    'customer': 'BigCo',
    'performances': [
      {'playID': 'hamlet', 'audience': 55},
      {'playID': 'as-like', 'audience': 35},
      {'playID': 'othello', 'audience': 40},
    ],
  };

  var plays = {
    'hamlet': {'name': 'Hamlet', 'type': 'tragedy'},
    'as-like': {'name': 'As You Like It', 'type': 'comedy'},
    'othello': {'name': 'Othello', 'type': 'tragedy'},
  };

  final chapter01 = Chapter01(invoice: invoice, plays: plays);

  print(chapter01.statement(invoice, plays));
}

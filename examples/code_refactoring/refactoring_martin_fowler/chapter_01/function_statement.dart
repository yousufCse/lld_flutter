// ignore_for_file: avoid_print

import 'dart:math';

class Chapter01 {
  Chapter01({required this.invoice, required this.plays});

  final Map<String, dynamic> invoice;
  final Map<String, dynamic> plays;

  String statement(Map<String, dynamic> invoice, Map<String, dynamic> plays) {
    const Map<String, String> statementData = {};
    return renderPlainText(statementData, invoice, plays);
  }

  String renderPlainText(
    Map<String, String> data,
    Map<String, dynamic> invoice,
    Map<String, dynamic> plays,
  ) {
    var result = 'Statement for ${invoice['customer']}\n';

    for (var perf in invoice['performances']) {
      result +=
          ' ${playFor(perf)['name']}: ${format(amountFor(perf) / 100)} (${perf['audience']} seats)\n';
    }

    result += 'Amount owed is ${format(totalAmount() / 100)}\n';
    result += 'You earned ${totalVolumeCredits()} credits\n';
    return result;
  }

  double totalAmount() {
    var result = 0.0;

    for (var perf in invoice['performances']) {
      result += amountFor(perf);
    }
    return result;
  }

  int totalVolumeCredits() {
    var result = 0;
    for (var perf in invoice['performances']) {
      result += volumeCreditFor(perf);
    }
    return result;
  }

  String format(double aNumber) {
    return '\$${aNumber.toStringAsFixed(2)}';
  }

  double amountFor(Map<String, dynamic> aPerformance) {
    var result = 0.0;
    switch (playFor(aPerformance)['type']) {
      case 'tragedy':
        result = 40000;
        if (aPerformance['audience'] > 30) {
          result += 1000 * (aPerformance['audience'] - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (aPerformance['audience'] > 20) {
          result += 10000 + 500 * (aPerformance['audience'] - 20);
        }
        result += 300 * aPerformance['audience'];
        break;
      default:
        throw Exception('Unknown type: ${playFor(aPerformance)['type']}');
    }

    return result;
  }

  int volumeCreditFor(Map<String, dynamic> aPerformance) {
    var result = 0;
    result += max((aPerformance['audience'] as int) - 30, 0);

    if (playFor(aPerformance)['type'] == 'comedy') {
      result += (aPerformance['audience'] as int) ~/ 5;
    }
    return result;
  }

  Map<String, dynamic> playFor(Map<String, dynamic> aPerformance) {
    return plays[aPerformance['playID']] ?? {};
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

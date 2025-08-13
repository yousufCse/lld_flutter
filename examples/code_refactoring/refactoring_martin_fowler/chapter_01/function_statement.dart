// ignore_for_file: avoid_print

import 'dart:math';

class Chapter01 {
  Chapter01({required this.invoice, required this.plays});

  final Map<String, dynamic> invoice;
  final Map<String, dynamic> plays;

  final Map<String, dynamic> data = {};

  String statement(Map<String, dynamic> invoice, Map<String, dynamic> plays) {
    data.putIfAbsent('customer', () => invoice['customer'] ?? '');
    data.putIfAbsent(
      'performances',
      () => (invoice['performances'] ?? []).map(enrichPerformance).toList(),
    );
    data.putIfAbsent('totalAmount', () => totalAmount(data));
    data.putIfAbsent('totalVolumeCredits', () => totalVolumeCredits(data));
    return renderPlainText(data, plays);
  }

  String renderPlainText(
    Map<String, dynamic> data,
    Map<String, dynamic> plays,
  ) {
    var result = 'Statement for ${data['customer']}\n';

    for (var perf in data['performances']) {
      result +=
          ' ${perf['play']['name']}: ${format(perf['amount'] / 100)} (${perf['audience']} seats)\n';
    }

    result += 'Amount owed is ${format(data['totalAmount'] / 100)}\n';
    result += 'You earned ${data['totalVolumeCredits']} credits\n';
    return result;
  }

  Map<String, dynamic> enrichPerformance(Map<String, dynamic> aPerformance) {
    final result = Map<String, dynamic>.from(aPerformance);
    result.putIfAbsent('play', () => playFor(result));
    result.putIfAbsent('amount', () => amountFor(result));
    result.putIfAbsent('volumeCredits', () => volumeCreditFor(result));
    return result;
  }

  double totalAmount(Map<String, dynamic> data) {
    return data['performances']
        .map((perf) => perf['amount'] as double)
        .reduce((a, b) => a + b);
  }

  int totalVolumeCredits(Map<String, dynamic> data) {
    return data['performances']
        .map((perf) => perf['volumeCredits'] as int)
        .reduce((a, b) => a + b);
  }

  String format(double aNumber) {
    return '\$${aNumber.toStringAsFixed(2)}';
  }

  double amountFor(Map<String, dynamic> aPerformance) {
    var result = 0.0;
    switch (aPerformance['play']['type']) {
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
        throw Exception('Unknown type: ${aPerformance['play']['type']}');
    }

    return result;
  }

  int volumeCreditFor(Map<String, dynamic> aPerformance) {
    var result = 0;
    result += max((aPerformance['audience'] as int) - 30, 0);

    if (aPerformance['play']['type'] == 'comedy') {
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

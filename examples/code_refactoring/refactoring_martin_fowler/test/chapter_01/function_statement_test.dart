import 'package:flutter_test/flutter_test.dart';

import '../../chapter_01/function_statement.dart';

void main() {
  late final Chapter01 chapter01;

  setUp(() {
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
    chapter01 = Chapter01(invoice: invoice, plays: plays);
  });
  test(
    'Function statement generates correct output for given invoice and plays',
    () {
      var result = chapter01.statement();
      expect(result, contains('Statement for BigCo'));
      expect(result, contains('Hamlet: \$650.00 (55 seats)'));
      expect(result, contains('As You Like It: \$580.00 (35 seats)'));
      expect(result, contains('Othello: \$500.00 (40 seats)'));
      expect(result, contains('Amount owed is \$1730.00'));
      expect(result, contains('You earned 47 credits'));
    },
  );
}

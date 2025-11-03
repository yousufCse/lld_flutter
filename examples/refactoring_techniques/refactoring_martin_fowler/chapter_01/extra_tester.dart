// ignore_for_file: avoid_print

var invoice = {
  'customer': 'BigCo',
  'performances': [
    {'playID': 'hamlet', 'audience': 55},
    {'playID': 'as-like', 'audience': 35},
    {'playID': 'othello', 'audience': 40},
  ],
};

void statement(invoice, plays) {
  print(renderPlainText(createStatement(invoice, plays)));
}

void statementHtml(invoice, plays) {
  print(renderHtml(createStatement(invoice, plays)));
}

String renderPlainText(Map<String, dynamic> data) {
  var result = 'Statement for ${data['customer']}\n';
  for (var perf in data['performances']) {
    result +=
        'PlayID: ${perf['playID']}, '
        'Audience: ${perf['audience']}\n';
  }
  return result;
}

String renderHtml(Map<String, dynamic> data) {
  var result = '<h1>Statement for ${data['customer']}</h1>\n';
  result += '<table>\n';
  result += '<tr><th>Play</th><th>Seats</th><th>Cost</th></tr>\n';
  for (var perf in data['performances']) {
    result +=
        '<tr><td>${perf['playID']}</td>'
        '<td>${perf['audience']}</td>\n';
  }
  result += '</table>\n';
  return result;
}

Map<String, dynamic> createStatement(invoice, plays) {
  return {
    'customer': invoice['customer'],
    'performances': invoice['performances'].map((performance) {
      return {
        'playID': performance['playID'],
        'audience': performance['audience'],
      };
    }).toList(),
  }; // statement data
}

void main() {
  statement(invoice, {});
  statementHtml(invoice, {});
}

// dart run examples/code_refactoring/refactoring_martin_fowler/chapter_01/extra_tester.dart

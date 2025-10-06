// ignore_for_file: avoid_print

// Record Example
// -----------------------------------------
// Define a record type with named fields using a type alias

typedef UserRecord = ({String name, int age});

UserRecord userRecord = (age: 25, name: 'Alice');

// -----------------------------------------
// Function that returns a record with positional fields
(String, int) getUserInfo() {
  return ('Bob', 30);
}

void main(List<String> args) {
  print('Record Example');
  var userInfo = getUserInfo();
  print('Name: ${userInfo.$1}, Age: ${userInfo.$2}');
  print('--------------------------------');
  print('Name: ${userRecord.name}, Age: ${userRecord.age}');
}

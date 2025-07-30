// ignore_for_file: avoid_print

import 'package:injectable/injectable.dart';

abstract class PrintData {
  void printData();
}

@LazySingleton(as: PrintData, env: ['prod'])
class PrintDataProd implements PrintData {
  @override
  void printData() {
    print('Production data');
  }
}

@LazySingleton(as: PrintData, env: ['dev'])
class PrintDataDev implements PrintData {
  @override
  void printData() {
    print('Development data');
  }
}

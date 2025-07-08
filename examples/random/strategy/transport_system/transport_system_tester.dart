// ignore_for_file: avoid_print

/*

  Transport
  ---------
  speed: double
  ---------
  calculate(double distance);

  Car implemnts Transport
  speed: 100
  ----------------------
  calculate(double distance) {
    return speed * distance;
  }

  Bike implements Transport
  -------------------
  speed: 20
  -------------------
  calculate(double distance) {
    return speed * distance;
  }

  Walk implements Transport
  -------------------
  speed: 5
  -------------------
  calculate(double distance) {
    return speed * distance;
  } 

 */

import 'transport.dart';

void main(List<String> args) {
  print('Transport System Tester');
  TransportSystem transportSystem = TransportSystem();
  transportSystem.setTransport(Car());
  transportSystem.calculateTime(300); // 300 km distance
  transportSystem.setTransport(Bike());
  transportSystem.calculateTime(300); // 300 km distance
  transportSystem.setTransport(Walk());
  transportSystem.calculateTime(300); // 300 km distance
}

// ignore_for_file: avoid_print

abstract class Transport {
  Transport(this.speed);
  final double speed;

  double calculate(double distance) {
    return distance / speed;
  }
}

class Car extends Transport {
  Car() : super(80.0); // Speed in km/h
}

class Bike extends Transport {
  Bike() : super(20.0); // Speed in km/h
}

class Walk extends Transport {
  Walk() : super(5.0); // Speed in km/h
}

class TransportSystem {
  Transport? transport;

  void setTransport(Transport transport) {
    this.transport = transport;
  }

  void calculateTime(double distance) {
    if (transport == null) {
      print('No transport method selected.');
    } else {
      double time = transport!.calculate(distance);
      print(
        'Time taken: ${time.toStringAsFixed(2)} hours for distance $distance km using ${transport.runtimeType}.',
      );
    }
  }
}

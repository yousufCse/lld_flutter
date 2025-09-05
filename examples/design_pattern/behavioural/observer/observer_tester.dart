// ignore_for_file: avoid_print

abstract class Observer {
  void update(double temperature, double humidity, double pressure);
}

class CurrentConditionsDisplay implements Observer, DisplayElement {
  final Subject weatherData;
  double temperature = 0.0;
  double humidity = 0.0;

  CurrentConditionsDisplay(this.weatherData) {
    weatherData.registerObserver(this);
  }

  @override
  void display() {
    print("Current conditions: $temperature F degrees and $humidity% humidity");
  }

  @override
  void update(double temperature, double humidity, double pressure) {
    this.temperature = temperature;
    this.humidity = humidity;
    display();
  }
}

abstract class DisplayElement {
  void display();
}

abstract class Subject {
  void registerObserver(Observer observer);
  void removeObserver(Observer observer);
  void notifyObservers();
}

class WeatherData implements Subject {
  final List<Observer> _observers = [];

  double temperature = 0.0;
  double humidity = 0.0;
  double pressure = 0.0;

  void setMeasurements(double temperature, double humidity, double pressure) {
    this.temperature = temperature;
    this.humidity = humidity;
    this.pressure = pressure;
    measurementsChanged();
  }

  void measurementsChanged() {
    notifyObservers();
  }

  @override
  registerObserver(Observer observer) {
    _observers.add(observer);
  }

  @override
  removeObserver(Observer observer) {
    _observers.remove(observer);
  }

  @override
  notifyObservers() {
    for (var observer in _observers) {
      observer.update(temperature, humidity, pressure);
    }
  }
}

void main(List<String> args) async {
  final weatherData = WeatherData();
  final currentCondition = CurrentConditionsDisplay(weatherData);
  weatherData.setMeasurements(80, 65, 30.4);
  await Future.delayed(const Duration(seconds: 1));
  weatherData.setMeasurements(82, 70, 29.2);
  weatherData.removeObserver(currentCondition);
  await Future.delayed(const Duration(seconds: 3));
  weatherData.setMeasurements(78, 90, 29.2);
}

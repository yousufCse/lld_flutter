import 'package:equatable/equatable.dart';

class VitalSign extends Equatable {
  final String id;
  final String userId;
  final String? pulseRate;
  final String? oxygenSaturation;
  final String? hemoglobin;
  final String? respiratoryRate;
  final String? stressLevel;
  final String? bloodPressure;
  final int? locationTemperature;
  final String? location;
  final String? latitude;
  final String? longitude;
  final String? createdDate;
  final String? createdBy;
  final String? height;
  final String? weight;
  final String? bmi;
  final String? diabetesRisk;
  final String? recoveryAbility;
  final String? wellnessScore;
  final String? meanRri;
  final String? lfhf;
  final String? hypertensionRisk;
  final String? pnsindex;

  const VitalSign({
    required this.id,
    required this.userId,
    this.pulseRate,
    this.oxygenSaturation,
    this.hemoglobin,
    this.respiratoryRate,
    this.stressLevel,
    this.bloodPressure,
    this.locationTemperature,
    this.location,
    this.latitude,
    this.longitude,
    this.createdDate,
    this.createdBy,
    this.height,
    this.weight,
    this.bmi,
    this.diabetesRisk,
    this.recoveryAbility,
    this.wellnessScore,
    this.meanRri,
    this.lfhf,
    this.hypertensionRisk,
    this.pnsindex,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    pulseRate,
    oxygenSaturation,
    hemoglobin,
    respiratoryRate,
    stressLevel,
    bloodPressure,
    locationTemperature,
    location,
    latitude,
    longitude,
    createdDate,
    createdBy,
    height,
    weight,
    bmi,
    diabetesRisk,
    recoveryAbility,
    wellnessScore,
    meanRri,
    lfhf,
    hypertensionRisk,
    pnsindex,
  ];
}

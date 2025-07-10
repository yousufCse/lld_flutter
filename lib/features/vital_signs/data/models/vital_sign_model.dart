import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/vital_sign.dart';

part 'vital_sign_model.g.dart';

@JsonSerializable()
class VitalSignModel extends VitalSign {
  const VitalSignModel({
    required super.id,
    required super.userId,
    super.pulseRate,
    super.oxygenSaturation,
    super.hemoglobin,
    super.respiratoryRate,
    super.stressLevel,
    super.bloodPressure,
    super.locationTemperature,
    super.location,
    super.latitude,
    super.longitude,
    super.createdDate,
    super.createdBy,
    super.height,
    super.weight,
    super.bmi,
    super.diabetesRisk,
    super.recoveryAbility,
    super.wellnessScore,
    super.meanRri,
    super.lfhf,
    super.hypertensionRisk,
    super.pnsindex,
  });

  factory VitalSignModel.fromJson(Map<String, dynamic> json) =>
      _$VitalSignModelFromJson(json);

  Map<String, dynamic> toJson() => _$VitalSignModelToJson(this);
}

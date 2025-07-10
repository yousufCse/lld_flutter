// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_sign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalSignModel _$VitalSignModelFromJson(Map<String, dynamic> json) =>
    VitalSignModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      pulseRate: json['pulseRate'] as String?,
      oxygenSaturation: json['oxygenSaturation'] as String?,
      hemoglobin: json['hemoglobin'] as String?,
      respiratoryRate: json['respiratoryRate'] as String?,
      stressLevel: json['stressLevel'] as String?,
      bloodPressure: json['bloodPressure'] as String?,
      locationTemperature: (json['locationTemperature'] as num?)?.toInt(),
      location: json['location'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      createdDate: json['createdDate'] as String?,
      createdBy: json['createdBy'] as String?,
      height: json['height'] as String?,
      weight: json['weight'] as String?,
      bmi: json['bmi'] as String?,
      diabetesRisk: json['diabetesRisk'] as String?,
      recoveryAbility: json['recoveryAbility'] as String?,
      wellnessScore: json['wellnessScore'] as String?,
      meanRri: json['meanRri'] as String?,
      lfhf: json['lfhf'] as String?,
      hypertensionRisk: json['hypertensionRisk'] as String?,
      pnsindex: json['pnsindex'] as String?,
    );

Map<String, dynamic> _$VitalSignModelToJson(VitalSignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'pulseRate': instance.pulseRate,
      'oxygenSaturation': instance.oxygenSaturation,
      'hemoglobin': instance.hemoglobin,
      'respiratoryRate': instance.respiratoryRate,
      'stressLevel': instance.stressLevel,
      'bloodPressure': instance.bloodPressure,
      'locationTemperature': instance.locationTemperature,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'diabetesRisk': instance.diabetesRisk,
      'recoveryAbility': instance.recoveryAbility,
      'wellnessScore': instance.wellnessScore,
      'meanRri': instance.meanRri,
      'lfhf': instance.lfhf,
      'hypertensionRisk': instance.hypertensionRisk,
      'pnsindex': instance.pnsindex,
    };

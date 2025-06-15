import 'package:crystal_skin_mobile/models/user_model.dart';

class MedicalRecord {
  final int id;
  final String diagnoses;
  final String allergies;
  final String treatments;
  final String notes;
  final String bloodType;
  final double height;
  final double weight;
  final int? lastUpdatedByEmployeeId;
  final UserModel? lastUpdateByEmployee;

  MedicalRecord({
    required this.id,
    required this.diagnoses,
    required this.allergies,
    required this.treatments,
    required this.notes,
    required this.bloodType,
    required this.height,
    required this.weight,
    this.lastUpdatedByEmployeeId,
    this.lastUpdateByEmployee,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      diagnoses: json['diagnoses'],
      allergies: json['allergies'],
      treatments: json['treatments'],
      notes: json['notes'],
      bloodType: json['bloodType'],
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      lastUpdatedByEmployeeId: json['lastUpdatedByEmployeeId'],
      lastUpdateByEmployee: json['lastUpdateByEmployee'] != null
          ?  UserModel.fromJson(json['lastUpdateByEmployee'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagnoses': diagnoses,
      'allergies': allergies,
      'treatments': treatments,
      'notes': notes,
      'bloodType': bloodType,
      'height': height,
      'weight': weight,
      'lastUpdatedByEmployeeId': lastUpdatedByEmployeeId
    };
  }
}

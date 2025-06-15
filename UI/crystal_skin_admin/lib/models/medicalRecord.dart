class MedicalRecord {
  late int id;
  late String diagnoses;
  late String allergies;
  late String treatments;
  late String bloodType;
  late double height;
  late double weight;
  late String notes;
  late int? lastUpdatedByEmployeeId;

  MedicalRecord();

  MedicalRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diagnoses = json['diagnoses'];
    allergies = json['allergies'];
    treatments = json['treatments'];
    bloodType = json['bloodType'];
    height = json['height'] != null ? (json['height'] as num).toDouble() : 0.00;
    weight = json['weight'] != null ? (json['weight'] as num).toDouble() : 0.00;
    notes = json['notes'];
    lastUpdatedByEmployeeId = json['lastUpdatedByEmployeeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['diagnoses'] = diagnoses;
    data['allergies'] = allergies;
    data['treatments'] = treatments;
    data['bloodType'] = bloodType;
    data['height'] = height;
    data['weight'] = weight;
    data['notes'] = notes;
    return data;
  }
}
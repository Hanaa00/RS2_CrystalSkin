import 'package:crystal_skin_mobile/models/medical_record.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicalRecordProvider extends BaseProvider<MedicalRecord> {
  MedicalRecordProvider() : super('MedicalRecords');

  MedicalRecord? _medicalRecord;
  bool _isLoading = false;
  String? _error;

  MedicalRecord? get medicalRecord => _medicalRecord;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> getUserMedicalRecord() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      var uri = Uri.parse('${BaseProvider.apiUrl}/MedicalRecords/get-user-medical-record');

      var headers = Authorization.createHeaders();

      final response = await http.get(uri, headers: headers);

      print(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        _medicalRecord = fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load medical record: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  MedicalRecord fromJson(data) {
    return MedicalRecord.fromJson(data);
  }
}


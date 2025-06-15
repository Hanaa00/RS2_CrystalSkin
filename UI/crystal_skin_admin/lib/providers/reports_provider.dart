import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/authorization.dart';

class ReportsProvider with ChangeNotifier {
  static String apiUrl = "";
  final Dio _dio = Dio();

  ReportsProvider() {
    apiUrl = dotenv.env['API_URL']!;
  }

  Future<Uint8List> downloadPatientsReport({
    String? searchFilter,
    bool? isPatient,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reports/patients').replace(
        queryParameters: {
          if (searchFilter != null) 'SearchFilter': searchFilter,
          if (isPatient != null) 'IsPatient': isPatient.toString(),
          if (pageNumber != null) 'PageNumber': pageNumber.toString(),
          if (pageSize != null) 'PageSize': pageSize.toString(),
        },
      );

      final response = await _dio.getUri<Uint8List>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          headers: Authorization.createHeaders(),
        ),
      );

      return response.data!;
    } catch (e) {
      throw Exception('Greška pri preuzimanju izvještaja: ${e.toString()}');
    }
  }

  Future<Uint8List> downloadOrdersReport({
    String? searchFilter,
    String? status,
    int? pageNumber,
    int? pageSize,
  }) async {
    try {
      final uri = Uri.parse('$apiUrl/reports/orders').replace(
        queryParameters: {
          if (searchFilter != null) 'SearchFilter': searchFilter,
          if (status != null) 'Status': status,
          if (pageNumber != null) 'PageNumber': pageNumber.toString(),
          if (pageSize != null) 'PageSize': pageSize.toString(),
        },
      );

      final response = await _dio.getUri<Uint8List>(
        uri,
        options: Options(
          responseType: ResponseType.bytes,
          headers: Authorization.createHeaders(),
        ),
      );

      return response.data!;
    } catch (e) {
      throw Exception('Greška pri preuzimanju izvještaja: ${e.toString()}');
    }
  }
}
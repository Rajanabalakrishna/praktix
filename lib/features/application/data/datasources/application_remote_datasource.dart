import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/application_model.dart';

abstract class ApplicationRemoteDatasource {
  Future<String> submitApplication(ApplicationModel model);
}

class ApplicationRemoteDatasourceImpl implements ApplicationRemoteDatasource {
  final http.Client client;
  const ApplicationRemoteDatasourceImpl({required this.client});

  @override
  Future<String> submitApplication(ApplicationModel model) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.ngrokurl}/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': model.name,
          'email': model.email,
          'phone': model.phone,
          'programTitle': model.programTitle,
        }),
      );

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded['message'] as String? ?? 'Application submitted successfully!';
      } else {
        throw ServerException(
          message: decoded['message'] as String? ?? 'Submission failed.',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Network error: ${e.toString()}');
    }
  }
}
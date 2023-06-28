import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_final/src/auth/auth_service.dart';
import 'package:projeto_final/src/registration/registration.dart';


class RegistrationService {
  static const String _apiBasePath = ConstConfigs.apiUrl;

  Future<({bool error, String reason})> store(Registration registration) async {
    final payload = {
      "name": registration.name,
      "password": registration.password,
      "email": registration.email,
      "cpf": registration.cpf,
      "bourned": registration.bourned,
    };

    final response = await http.post(
      Uri.parse('$_apiBasePath/api/register'),
      body: json.encode(payload),
      headers: _headers(),
    );

    return (
    error: response.statusCode != 200,
    reason: "Falha ao cadastrar o usuário."
    );
  }

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

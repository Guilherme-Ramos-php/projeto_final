import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projeto_final/src/auth/user.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  static const String _authTokenKey = 'auth_token';
  static const String _idPessoa = 'id_pessoa';
  static const String _apiBasePath = ConstConfigs.apiUrl;

  User? _user;
  final _storage = const FlutterSecureStorage();

  User? get user {
    return _user;
  }

  Future initUser() async {
    _user = null;
  }

  Future login(String email, String password) async {
    final payload = {
      'username': email,
      'password': password,
    };
    final response = await http.post(
      Uri.parse(
        '$_apiBasePath/api/login_check',
      ),
      body: jsonEncode(payload),
      headers: await _header(false),
    );

    final responseJson = jsonDecode(response.body);

    if (response.statusCode != 200) {
      if(response.statusCode >= 400 && response.statusCode <= 499){
        return 'Falha ao fazer login: \n Credenciais invalidas';
      }
      else{
        return 'Falha ao fazer login: \n Falha no Servidor';
      }

    } else {
      await _storage.write(
        key: _authTokenKey,
        value: responseJson['token'],
      );



      _user = User(
          id: responseJson['user']['id'],
          email: responseJson['user']['email'],
          name: responseJson['user']['name'],
          cpf: responseJson['user']['cpf']);
      notifyListeners();

      await _storage.write(
        key: 'user',
        value: responseJson['user']['id'].toString(),
      );
      return true;
    }
  }


  Future<bool> hasToken() async {
    String? authToken = await _storage.read(key: _authTokenKey);

    if (authToken != null) {
      return true;
    }

    return false;
  }

  Future logout() async {
    _user = null;
    await _storage.delete(key: _authTokenKey);
  }

  Future<Map<String, String>> _header(bool isAuth) async {
    if (isAuth) {
      String? authToken = await _storage.read(key: _authTokenKey);

      if (authToken == null) {
        throw Exception('Not Logged.');
      }

      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
      };
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

class ConstConfigs {
  static const apiUrl = "http://192.168.1.49:8080";
}

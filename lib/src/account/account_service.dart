import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_final/src/account/account.dart';
import 'package:projeto_final/src/lib/service/abstract_service.dart';
import 'package:projeto_final/src/transaction/transaction.dart';

class AccountService extends BaseService {
  static const _uri = BaseService.apiBasePath;


  Future<List<Account>> getAccounts() async {
    final response = await http.get(
      Uri.parse(
        "$_uri/api/conta/all",
      ),
      headers: await header(true),
    );

    final responseJson = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return [];
    }

    List<Account> output = [];
    for (var data in responseJson) {
      output.add(Account.fromJson(data));
    }

    return output;
  }

  Future<List<Transaction>> getTransactions(String conta) async {
    final response = await http.get(
      Uri.parse(
        "$_uri/api/conta/$conta",
      ),
      headers: await header(true),
    );

    final responseJson = jsonDecode(response.body);

     if (response.statusCode != 200) {
      return [];
    }

    List<Transaction> output = [];
    for (var data in responseJson) {
      for(var transaction in data['movimentacoes']){
        print(transaction);
        output.add(Transaction.fromJson(transaction));
      }
    }

    print(output);
    return output;
  }

  Future createAccount(String descricao, int idPessoa) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_uri/api/conta/gerar_conta',
        ),
        body: jsonEncode({'id_pessoa': idPessoa, 'descricao': descricao}),
        headers: await header(true),
      );


      if (response.statusCode >= 300) {
        throw Exception(
            'Algo incesperado aconteceu! : ${response.reasonPhrase} \n ');
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future updateAccount(String descricao, int? idAccount) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$_uri/api/conta/edit/$idAccount',
        ),
        body: jsonEncode({'descricao': descricao}),
        headers: await header(true),
      );
      if (response.statusCode >= 300) {
        throw Exception(
            'Algo incesperado aconteceu! :${response.reasonPhrase}');
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteAccount(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_uri/api/conta/$id'),
          headers: await header(true));

      if (response.statusCode != 200) {
        throw Exception(
            'Algo incesperado aconteceu! : ${response.reasonPhrase}');
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

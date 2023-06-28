import 'package:http/http.dart' as http;
import 'package:projeto_final/src/lib/service/abstract_service.dart';
import 'package:projeto_final/src/transaction/transaction.dart';

class TransactionService extends BaseService {
  static const _uri = BaseService.apiBasePath;


  Future createTransaction(Transaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_uri/api/movimentacao',
        ),
        body: transaction.toJson(),
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


}

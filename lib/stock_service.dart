import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  Future<double?> fetchCurrentPrice(String symbol) async {
    final uri = Uri.parse(
      '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final priceString = data['Global Quote']?['05. price'];
        if (priceString != null) {
          return double.tryParse(priceString);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

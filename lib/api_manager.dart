import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
class StockAPI {
  static const csvUrl =
      'https://query1.finance.yahoo.com/v7/finance/download/IBM?period1=1561939200&period2=1623235799&interval=1d&events=history&includeAdjustedClose=true';

  Future<List<List<dynamic>>> fetchStockData() async {
    final response = await http.get(Uri.parse(csvUrl));
    final decodedContent = response.body;

    const csvParser = CsvToListConverter();
    final parsedCsv = csvParser.convert(decodedContent);

    return parsedCsv;
  }


}

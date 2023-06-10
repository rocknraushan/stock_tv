import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_tv/splash_screen/splash_screen.dart';
import 'package:stock_tv/utils/app_theme.dart';
import 'package:stock_tv/utils/route_generator.dart';
import 'api_manager.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FirebasePhoneAuthHandler Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: SplashScreen.id,
    );
  }
}
//
// class StockPage extends StatefulWidget {
//   const StockPage({super.key});
//
//   @override
//   _StockPageState createState() => _StockPageState();
// }
//
// class _StockPageState extends State<StockPage> {
//   String stockData = '';
//   List<List<dynamic>> csvList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchStockData();
//   }
//
//   Future<void> fetchStockData() async {
//     try {
//       final api = StockAPI();
//       // final data = await api.getStockData();
//       final csvData = await api.fetchStockData();
//       setState(() {
//         // stockData = data;
//         csvList = csvData;
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error fetching stock data: $e');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stock App'),
//       ),
//       body: Center(
//           child: Column(
//         children: [
//           const Text('stockData'),
//             Container(
//                 height: MediaQuery.of(context).size.height / 1.5,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.rectangle,
//                 ),
//               child: ListView.builder(
//                 itemCount: csvList.length,
//                 itemBuilder: (context, index) {
//                   final row = csvList[index];
//                   return ListTile(
//                     title: Text(row[0].toString()),
//                     subtitle: Text(row[1].toString()),
//                   );
//                 }),
//           )
//         ],
//       )),
//     );
//   }
// }

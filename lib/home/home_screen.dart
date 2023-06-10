import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:stock_tv/utils/app_theme.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';



class HomeScreen extends StatelessWidget {
  static const id = 'HomeScreen';
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BottomSelectionWidget(),
    );
  }
}

class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yahoo Finance Screener'),
        backgroundColor: const Color.fromRGBO(0, 126, 106, 1),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onItemSelected,
          children: const [
            YahooFinanceServiceWidget(),
            DTOSearch(),
            RawSearch(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemSelected,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Service',
            backgroundColor: Color.fromRGBO(0, 126, 106, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered),
            label: 'DTO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.raw_on,),
            label: 'Raw',

          ),
        ],
      ),
      drawer: ,
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      _selectedIndex = index;
    });
    debugPrint(index.toString());
  }
}

class RawSearch extends StatefulWidget {
  const RawSearch({
    super.key,
  });

  @override
  State<RawSearch> createState() => _RawSearchState();
}

class _RawSearchState extends State<RawSearch> {
  @override
  Widget build(BuildContext context) {
    String ticker = 'GOOG';
    YahooFinanceDailyReader yahooFinanceDataReader =
    const YahooFinanceDailyReader();

    Future<Map<String, dynamic>> future =
    yahooFinanceDataReader.getDailyData(ticker);

    return FutureBuilder(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Text('No data');
          }

          Map<String, dynamic> historicalData = snapshot.data!;
          return SingleChildScrollView(
            child: Text(historicalData.toString()),
          );
        } else if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        return const Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  String generateDescription(DateTime date, Map<String, dynamic> day) {
    return '''$date
open: ${day['open']}
close: ${day['close']}
high: ${day['high']}
low: ${day['low']}
adjclose: ${day['adjclose']}
''';
  }
}

class DTOSearch extends StatefulWidget {
  const DTOSearch({super.key});

  @override
  State<DTOSearch> createState() => _DTOSearchState();
}

class _DTOSearchState extends State<DTOSearch> {
  final TextEditingController controller = TextEditingController(
    text: 'GOOG',
  );
  late Future<YahooFinanceResponse> future;

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Ticker from yahoo finance'),
        TextField(
          controller: controller,
        ),
        MaterialButton(
          onPressed: load,
          color: Theme.of(context).primaryColor,
          child: const Text('Load'),
        ),
        Expanded(
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context,
                AsyncSnapshot<YahooFinanceResponse> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return const Text('No data');
                }

                YahooFinanceResponse response = snapshot.data!;
                return ListView.builder(
                    itemCount: response.candlesData.length,
                    itemBuilder: (BuildContext context, int index) {
                      YahooFinanceCandleData candle =
                      response.candlesData[index];

                      return _CandleCard(candle);
                    });
              } else {
                return const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void load() {
    future = const YahooFinanceDailyReader().getDailyDTOs(controller.text);
    setState(() {});
  }
}

class _CandleCard extends StatelessWidget {
  final YahooFinanceCandleData candle;

  const _CandleCard(this.candle);

  @override
  Widget build(BuildContext context) {
    final String date = candle.date.toIso8601String().split('T').first;

    return Card(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(date),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('open: ${candle.open.toStringAsFixed(2)}'),
                Text('close: ${candle.close.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('low: ${candle.low.toStringAsFixed(2)}'),
                Text('high: ${candle.high.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class YahooFinanceServiceWidget extends StatefulWidget {
  const YahooFinanceServiceWidget({super.key});

  @override
  State<YahooFinanceServiceWidget> createState() =>
      _YahooFinanceServiceWidgetState();
}

class _YahooFinanceServiceWidgetState extends State<YahooFinanceServiceWidget> {
  TextEditingController controller = TextEditingController(
    text: 'GOOG',
  );
  List<YahooFinanceCandleData> pricesList = [];
  List? cachedPrices;
  bool loading = true;
  DateTime? startDate;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    loading = false;
    setState(() {});

    // Get response for the first time
    pricesList = await YahooFinanceService()
        .getTickerData(controller.text, startDate: startDate);

    // Check if the cache was created
    cachedPrices = await YahooFinanceDAO().getAllDailyData(
      controller.text,
    );
    loading = false;
    setState(() {});
  }

  void deleteCache() async {
    loading = true;
    setState(() {});

    await YahooFinanceDAO().removeDailyData(controller.text);
    cachedPrices = await YahooFinanceDAO().getAllDailyData(controller.text);
    loading = false;
    setState(() {});
  }

  void refresh() async {
    cachedPrices = await YahooFinanceDAO().getAllDailyData(controller.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: pricesList.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          final List<String> tickerOptions = [
            'GOOG',
            'ES=F, GC=F',
            'GOOG, AAPL',
          ];
          return Card(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: tickerOptions
                          .map(
                            (option) => Container(
                          margin: const EdgeInsets.all(5),
                          child: MaterialButton(
                            child: Text(option),
                            onPressed: controller.text == option
                                ? null
                                : () => setState(() {
                              controller.text = option;
                            }),
                            color: Colors.lightGreen,
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        startDate != null
                            ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(startDate!)}'
                            : 'No Date Selected',
                      ),
                      MaterialButton(
                        onPressed: () {
                          // DatePicker.showDatePicker(
                          //   context,
                          //   showTitleActions: true,
                          //   onConfirm: (date) {
                          //     setState(() {
                          //       startDate = date;
                          //     });
                          //   },
                          // );
                        },
                        child: const Text(
                          'Select Date',
                        ),
                      ),
                    ],
                  ),
                  const Text('Ticker from yahoo finance:'),
                  TextField(
                    controller: controller,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: AppTheme.lightTheme.appBarTheme.backgroundColor,
                        onPressed: () => load(),
                        child: const Text('Load'),
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => deleteCache(),
                        child: const Text('Delete Cache'),
                      ),
                      MaterialButton(
                        color: AppTheme.lightTheme.splashColor,
                        onPressed: () => refresh(),
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                  Text('Prices in the service ${pricesList.length}'),
                  Text('Prices in the cache ${cachedPrices?.length}'),
                  pricesList.isEmpty
                      ? const Text('No data')
                      : const SizedBox.shrink()
                ],
              ),
            ),
          );
        } else {
          final YahooFinanceCandleData candleData = pricesList[i - 1];
          return _CandleCard(
            candleData,
          );
        }
      },
    );
  }
}
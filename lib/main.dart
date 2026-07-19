import 'package:flutter/material.dart';
import 'stock_service.dart';

void main() {
  runApp(const StockReturnApp());
}

class StockReturnApp extends StatelessWidget {
  const StockReturnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Return Calculator',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _symbolController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _currentPriceController = TextEditingController();

  final StockService _stockService = StockService();

  double? _returnAmount;
  double? _returnPercent;
  bool _isLoading = false;

  Future<void> _fetchLivePrice() async {
    final symbol = _symbolController.text.trim();
    if (symbol.isEmpty) return;

    setState(() => _isLoading = true);
    final price = await _stockService.fetchCurrentPrice(symbol);
    setState(() {
      _isLoading = false;
      if (price != null) {
        _currentPriceController.text = price.toStringAsFixed(2);
      }
    });
  }

  void _calculateReturn() {
    final buyPrice = double.tryParse(_buyPriceController.text);
    final currentPrice = double.tryParse(_currentPriceController.text);
    final quantity = double.tryParse(_quantityController.text);

    if (buyPrice == null || currentPrice == null || quantity == null) {
      return;
    }

    final invested = buyPrice * quantity;
    final currentValue = currentPrice * quantity;
    final gain = currentValue - invested;
    final percent = invested == 0 ? 0.0 : (gain / invested) * 100.0;

    setState(() {
      _returnAmount = gain.toDouble();
      _returnPercent = percent.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Return Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _symbolController,
              decoration: const InputDecoration(
                labelText: 'Stock Symbol',
                hintText: 'AAPL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buyPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Buy Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _currentPriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Current Price',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchLivePrice,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    label: const Text('Get Live Price'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calculateReturn,
                    child: const Text('Calculate Return'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_returnAmount != null && _returnPercent != null)
              Card(
                color: _returnAmount! >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _returnAmount! >= 0 ? 'Profit' : 'Loss',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Return amount: ${_returnAmount!.toStringAsFixed(2)}'),
                      Text('Return %: ${_returnPercent!.toStringAsFixed(2)}%'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


/* class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/

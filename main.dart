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
    final percent = invested == 0 ? 0 : (gain / invested) * 100;

    setState(() {
      _returnAmount = gain;
      _returnPercent = percent;
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                color: _returnAmount! >= 0
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _returnAmount! >= 0 ? 'Profit' : 'Loss',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Return amount: ${_returnAmount!.toStringAsFixed(2)}'),
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

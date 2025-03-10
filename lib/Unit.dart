import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: UnitConverterScreen(),
    );
  }
}

class UnitConverterScreen extends StatefulWidget {
  @override
  _UnitConverterScreenState createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  double _result = 0.0;

  String _selectedCategory = 'Length';
  String _fromUnit = 'Kilometers';
  String _toUnit = 'Meters';

  final Map<String, Map<String, double>> _conversionRates = {
    'Length': {
      'Kilometers': 1,
      'Meters': 1000,
    },
    'Temperature': {
      'Celsius': 1,
      'Fahrenheit': 1, // Special handling needed
      'Kelvin': 1,     // Special handling needed
    },
  };

  void _convert() {
    double inputValue = double.tryParse(_inputController.text) ?? 0.0;

    if (_selectedCategory == 'Temperature') {
      if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
        _result = (inputValue * 9 / 5) + 32;
      } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
        _result = inputValue + 273.15;
      } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
        _result = (inputValue - 32) * 5 / 9;
      } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
        _result = (inputValue - 32) * 5 / 9 + 273.15;
      } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
        _result = inputValue - 273.15;
      } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
        _result = (inputValue - 273.15) * 9 / 5 + 32;
      } else {
        _result = inputValue;
      }
    } else {
      double fromRate = _conversionRates[_selectedCategory]?[_fromUnit] ?? 1;
      double toRate = _conversionRates[_selectedCategory]?[_toUnit] ?? 1;
      _result = (inputValue / fromRate) * toRate;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unit Converter 🌎")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _conversionRates.keys.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (newCategory) {
                setState(() {
                  _selectedCategory = newCategory!;
                  _fromUnit = _conversionRates[_selectedCategory]!.keys.first;
                  _toUnit = _conversionRates[_selectedCategory]!.keys.last;
                });
              },
            ),
            SizedBox(height: 20),

            // Input Field
            Text("Enter Value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter a number", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),

            // From Unit
            Text("From Unit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              items: _conversionRates[_selectedCategory]!.keys.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (newUnit) {
                setState(() {
                  _fromUnit = newUnit!;
                });
              },
            ),
            SizedBox(height: 20),

            // To Unit
            Text("To Unit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              items: _conversionRates[_selectedCategory]!.keys.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit));
              }).toList(),
              onChanged: (newUnit) {
                setState(() {
                  _toUnit = newUnit!;
                });
              },
            ),
            SizedBox(height: 20),

            // Convert Button
            Center(
              child: ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                child: Text("Convert", style: TextStyle(fontSize: 18)),
              ),
            ),

            SizedBox(height: 30),

            // Result
            Center(
              child: Text(
                "Result: $_result $_toUnit",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

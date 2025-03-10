
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController con1 = TextEditingController();
  TextEditingController con2 = TextEditingController();
  double res = 0;

  void update(String oper) {
    setState(() {
      double num1 = double.tryParse(con1.text) ?? 0;
      double num2 = double.tryParse(con2.text) ?? 0;

      if (oper == '+') {
        res = num1 + num2;
      } else if (oper == '-') {
        res = num1 - num2;
      } else if (oper == '*') {
        res = num1 * num2;
      } else if (oper == '/') {
        res = num2 != 0 ? num1 / num2 : 0;
      } else if (oper == 'USD') {
        res = num1 * 0.011;
      } else if (oper == 'EUR') {
        res = num1 * 0.0105;
      } else if (oper == 'JPY') {
        res = num1 * 1.69;
      } else if (oper == 'GBP') {
        res = num1 * 0.0089;
      }
    });
  }

  void clearFields() {
    setState(() {
      con1.clear();
      con2.clear();
      res = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calculator & Currency Converter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          elevation: 5,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Input Fields
                _buildTextField(con1, "Enter Number 1 (INR for conversion)"),
                const SizedBox(height: 10),
                _buildTextField(con2, "Enter Number 2 (For Arithmetic)"),
                const SizedBox(height: 20),

                // Arithmetic Buttons
                _buildButtonRow(['+', '-', '*', '/'], Colors.orange),

                const SizedBox(height: 20),

                // Currency Conversion Buttons
                _buildButtonRow(['USD', 'EUR'], Colors.green),
                const SizedBox(height: 10),
                _buildButtonRow(['JPY', 'GBP'], Colors.blue),

                const SizedBox(height: 20),

                // Clear Button
                ElevatedButton(
                  onPressed: clearFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Clear",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 30),

                // Display Result
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Result: $res",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build TextFields
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Function to build button rows
  Widget _buildButtonRow(List<String> operations, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: operations.map((op) {
        return ElevatedButton(
          onPressed: () => update(op),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
          ),
          child: Text(
            op,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}

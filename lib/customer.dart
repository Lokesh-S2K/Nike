import 'package:flutter/material.dart';

// Customer model class
class Customer {
  String name;
  int age;
  String phone;

  Customer({required this.name, required this.age, required this.phone});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomerListScreen(),
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  // List to store customer data
  List<Customer> customers = [];

  // Method to add a new customer
  void _addCustomer(String name, int age, String phone) {
    setState(() {
      customers.add(Customer(name: name, age: age, phone: phone));
    });
  }

  // Method to edit customer details
  void _editCustomer(int index, String name, int age, String phone) {
    setState(() {
      customers[index] = Customer(name: name, age: age, phone: phone);
    });
  }

  // Method to delete a customer
  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
  }

  // UI to show the list of customers and add/edit/delete options
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Manager'),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(customers[index].name),
            subtitle: Text('Age: ${customers[index].age}, Phone: ${customers[index].phone}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteCustomer(index);
              },
            ),
            onTap: () {
              // Show Edit Dialog on tap
              _showEditDialog(context, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show Add Customer Dialog
          _showAddDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Show dialog to add a new customer
  void _showAddDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: ageController, decoration: InputDecoration(labelText: 'Age')),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text;
                int age = int.tryParse(ageController.text) ?? 0;
                String phone = phoneController.text;
                _addCustomer(name, age, phone);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to edit customer details
  void _showEditDialog(BuildContext context, int index) {
    TextEditingController nameController = TextEditingController(text: customers[index].name);
    TextEditingController ageController = TextEditingController(text: customers[index].age.toString());
    TextEditingController phoneController = TextEditingController(text: customers[index].phone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: ageController, decoration: InputDecoration(labelText: 'Age')),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String name = nameController.text;
                int age = int.tryParse(ageController.text) ?? 0;
                String phone = phoneController.text;
                _editCustomer(index, name, age, phone);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

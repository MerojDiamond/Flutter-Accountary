import 'package:flutter/material.dart';
import 'package:accountary/db/db.dart';
import 'package:accountary/pages/transactions.dart';

void main() async {
  // Initialize the database
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyDaybookApp());
}

class MyDaybookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Дневник расходов',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransactionsListPage(),
    );
  }
}
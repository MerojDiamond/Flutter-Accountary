import 'package:accountary/db/db.dart';
import 'package:accountary/db/models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  int _type = -1;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Добавление транзакции',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            RadioListTile(
                title: const Text("Расход"),
                value: -1,
                groupValue: _type,
                onChanged: (v) {
                  setState(() {
                    _type = v ?? _type;
                  });
                }),
            RadioListTile(
                title: const Text("Доход"),
                value: 1,
                groupValue: _type,
                onChanged: (v) {
                  setState(() {
                    _type = v ?? _type;
                  });
                }),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(hintText: "Сумма транзакции"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Название"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: "Описание"),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 10),
            FilledButton(
                onPressed: () async {
                  DBProvider _dbProvider = DBProvider();
                  final dbPath = await getDatabasesPath();
                  final path = join(dbPath, 'main.db');
                  _dbProvider.open(path).then((v) {
                    DateTime now = new DateTime.now();
                    var formatter = new DateFormat('yyyy-MM-dd');
                    String formattedDate = formatter.format(now);
                    _dbProvider.insertTransaction(new RaceTransaction(
                      0,
                      _type,
                      int.parse(_amountController.text),
                      _titleController.text,
                      _descriptionController.text,
                      formattedDate,
                    ));
                    Navigator.of(context).pop();
                  });
                },
                child: Text("Добавить"))
          ],
        ),
      ),
    );
  }
}

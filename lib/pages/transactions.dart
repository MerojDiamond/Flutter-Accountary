import 'package:accountary/db/models/Transaction.dart';
import 'package:accountary/pages/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:accountary/db/db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionsListPage extends StatefulWidget {
  @override
  TransactionsListPageState createState() => TransactionsListPageState();
}

class TransactionsListPageState extends State<TransactionsListPage> {
  Future<List<RaceTransaction>>? _transactions;
  DBProvider _dbProvider = new DBProvider();
  int _sum = 0;

  @override
  void initState() {
    super.initState();
    _loadConsumptions();
  }

  _loadConsumptions() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'main.db');
    _dbProvider.open(path).then((v) =>
    {
      setState(() {
        _transactions = _dbProvider.getTransactions();
        _transactions?.then((value) =>
        {
          value.forEach((element) {
            _sum += element.amount * element.type;
          })
        });
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Дневник транзакций',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddTransaction();
            })).then((value) {
              setState(() {
                _transactions = null;
                _transactions = _dbProvider.getTransactions();
                _sum = 0;
                _transactions?.then((value) {
                  value.forEach((element) {
                    setState(() {
                      _sum += element.amount * element.type;
                    });
                  });
                });
              });
            });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Text(
            "Сумма: " + _sum.toString(),
            style: Theme
                .of(context)
                .textTheme
                .headlineSmall,
          ),
        ),
        body: FutureBuilder(
          future: _transactions,
          builder: (context, snapshot) {
            print(snapshot.data == null || snapshot.data?.length == 1);
            if (snapshot.data == null || snapshot.data?.length == 0) {
              return Center(
                child: Text(
                  "Нет данных",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
                ),
              );
            } else if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final transaction = snapshot.data?[index];
                  return ListTile(
                    title: Text(
                        '${transaction?.type == 1
                            ? 'Доход'
                            : 'Расход'}: ${transaction?.title} - ${transaction
                            ?.amount}'),
                    subtitle: Text(
                        '${transaction?.description}\n${transaction?.date}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _dbProvider
                            .daleteTransaction(transaction?.id ?? 0)
                            .then((value) {
                          setState(() {
                            _transactions = null;
                            _transactions = _dbProvider.getTransactions();
                            _sum = 0;
                            _transactions?.then((value) {
                              value.forEach((element) {
                                setState(() {
                                  _sum += element.amount * element.type;
                                });
                              });
                            });
                          });
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              );
            }
            return Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blue),
            );
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:lab2/repository/ExpensesRepo.dart';
import 'package:postgres/postgres.dart';

import 'expensesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Expenses'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ExpensesRepository dbRepo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupDatabase();
  }

  Future<void> _setupDatabase() async {
    var connection = PostgreSQLConnection(
      '192.168.0.154',
      5432,
      'mobile',
      username: 'postgres',
      password: 'ama',
    );

    dbRepo = ExpensesRepository(connection);
    await dbRepo.openConnection();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : ExpensesPage(title: widget.title, repo: dbRepo);
  }

  @override
  void dispose() {
    dbRepo.closeConnection();
    super.dispose();
  }
}




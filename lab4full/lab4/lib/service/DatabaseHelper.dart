import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../domain/Expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      currency TEXT NOT NULL,
      date TEXT NOT NULL,
      description TEXT NOT NULL,
      is_new INTEGER NOT NULL DEFAULT 0,
      is_updated INTEGER NOT NULL DEFAULT 0,
      is_deleted INTEGER NOT NULL DEFAULT 0,
      is_synced INTEGER NOT NULL DEFAULT 0
    )
    ''');
  }

  Future<Expense> createExpense(Expense expense) async {
    final db = await instance.database;
    final map = expense.toLocalMap();
    map['is_new'] = 1; // Since it's a new record
    map['is_synced'] = 0; // Not synced yet
    final id = await db.insert('expenses', map);
    return expense.copyWith(id: id);
  }

  // Read all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await instance.database;
    // Query the expenses table to retrieve rows where is_deleted is not 1
    final result = await db.query(
      'expenses',
      where: 'is_deleted = 0', // Only select expenses that are not marked as deleted
    );
    return result.map((json) => Expense.fromLocalMap(json)).toList();
  }

  Future<void> deleteAllExpensesAndResetIndex() async {
    final db = await instance.database;
    await db.transaction((txn) async {
      // Delete all entries from the expenses table
      await txn.delete('expenses');

      // Reset the auto-increment counter
      // SQLite does not have a TRUNCATE TABLE command, so we use DELETE and then reset the sequence
      await txn.execute('DELETE FROM sqlite_sequence WHERE name = ?', ['expenses']);
    });
  }


  Future<int> updateExpense(Expense expense) async {
    final db = await instance.database;
    final map = expense.toLocalMap();
    map['is_updated'] = 1; // Since the record has been updated
    map['is_synced'] = 0; // Not synced yet
    return db.update(
      'expenses',
      map,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(Expense expense) async {
    final db = await instance.database;
    // Instead of actually deleting the record, you might want to mark it as deleted
    final map = {
      'is_deleted': 1, // Marked for deletion
      'is_synced': 0, // Not synced yet
    };
    return db.update(
      'expenses',
      map,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<List<Map<String, dynamic>>> getUnsyncedExpenses() async {
    final db = await database;
    // Retrieve expenses that are marked as unsynced
    return db.query('expenses', where: 'is_synced = 0');
  }

  // Mark an expense as synced
  Future<void> markAsSynced(Expense expense) async {
    final db = await instance.database;

    // First, check if the expense is marked as deleted
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [expense.id],
      columns: ['is_deleted'],
    );

    if (maps.isNotEmpty && maps.first['is_deleted'] == 1) {
      // If the expense is marked as deleted, delete it from the local database
      await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    } else {
      // Otherwise, just mark it as synced
      final map = {
        'is_new': 0, // Reset the flags as the record is now synced
        'is_updated': 0,
        'is_deleted': 0,
        'is_synced': 1, // Mark as synced
      };
      await db.update(
        'expenses',
        map,
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> updateLocalDatabase(List<Expense> latestExpenses) async {
    final db = await database;
    Batch batch = db.batch();

    // A set of all IDs from the latest server data
    var serverIds = latestExpenses.map((e) => e.id).toSet();

    // Get all local expense IDs
    List<Map<String, dynamic>> localExpenses =
        await db.query('expenses', columns: ['id']);
    var localIds = localExpenses.map((e) => e['id'] as int).toSet();

    // Insert or update server expenses in the local database
    for (var expense in latestExpenses) {
      batch.insert(
        'expenses',
        expense.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Identify and remove local expenses that are no longer on the server
    var idsToDelete = localIds.difference(serverIds);
    for (var id in idsToDelete) {
      batch.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    await batch.commit(noResult: true);
  }
}

// Extension on Expense to handle cloning with a new ID
extension on Expense {
  Expense copyWith({int? id}) => Expense(
        id: id ?? this.id,
        name: name,
        category: category,
        amount: amount,
        currency: currency,
        date: date,
        description: description,
      );
}

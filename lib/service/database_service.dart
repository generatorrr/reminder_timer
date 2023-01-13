import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:reminder_timer/model/timer_entity.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static late Database database;


  Future<void> initializeDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}reminder_timer_database.db';
    // Open the database and store the reference.
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      path,
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE reminder_timer(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, description TEXT NOT NULL, interval INTEGER NOT NULL)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> create(TimerEntity? timerEntity) async {
    // Get a reference to the database.
    final db = database;

    if(timerEntity == null) {
      return;
    }

    // Insert the TimerEntity into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same entity is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'reminder_timer',
      timerEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<TimerEntity>> findAll() async {
    // Get a reference to the database.
    final db = database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('reminder_timer');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return TimerEntity(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        interval: maps[i]['interval'],
      );
    });
  }

  Future<void> update(TimerEntity timerEntity) async {
    // Get a reference to the database.
    final db = database;

    // Update the given Dog.
    await db.update(
      'reminder_timer',
      timerEntity.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [timerEntity.id],
    );
  }

  Future<TimerEntity> getById(int id) async {
    // Get a reference to the database.
    final db = database;

    // Update the given Dog.
    final List<Map<String, dynamic>> maps = await db.query(
      'reminder_timer',
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return TimerEntity(
      id: maps[0]['id'],
      name: maps[0]['name'],
      description: maps[0]['description'],
      interval: maps[0]['interval'],
    );
  }

  Future<void> delete(int? id) async {
    // Get a reference to the database.
    final db = database;

    // Remove the Dog from the database.
    await db.delete(
      'reminder_timer',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

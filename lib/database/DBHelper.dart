import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/model/Contacts.dart';

class DBHelper {
  final String TABLE_NAME = "Contact";

  static Database db_instance;

  Future<Database> get db async {
    if (db_instance == null) {
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Datenbank.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT); ');
  }

  Future<List<Contacts>> getContacts() async {
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Contacts> contacts = new List();

    for (int i = 0; i < list.length; i++) {
      Contacts contact = new Contacts();
      contact.id = list[i]['id'];
      contact.name = list[i]['name'];
      contact.phone = list[i]['phone'];

      contacts.add(contact);
    }

    return contacts;
  }

  void addNewContact(Contacts contact) async {
    var db_connection = await db;
    String query =
        'INSERT INTO $TABLE_NAME(name, phone) VALUES(\'${contact.name}\', \'${contact.phone}\');';
    await db_connection.transaction((transaction) async {
      var db_connection = await db;
      return await transaction.rawInsert(query);
    });
  }

  void updateContact(Contacts contact) async {
    var db_connection = await db;
    String query = 'UPDATE $TABLE_NAME SET name = \'${contact.name}\', phone = \'${contact.phone}\' WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async {
      var db_connection = await db;
      return await transaction.rawInsert(query);
    });
  }

  void deleteContact(Contacts contact) async {
    var db_connection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async {
      var db_connection = await db;
      return await transaction.rawInsert(query);
    });
  }
}

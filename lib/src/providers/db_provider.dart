import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

export 'package:qrreaderapp/src/models/scan_model.dart';


class DBProvider {

  static Database _database;
  static final DBProvider  db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if(_database != null) return _database;

    _database = await initDB();
    return _database;

  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join( documentsDirectory.path, 'ScanDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
      );
  }

 // CREATE REGISTER

  newScanRaw(ScanModel newScan) async {
    final db = await database;

    final resp = await db.rawInsert(
      "INSERT Into Scans (id, type, value) "
      "VALUES ( ${ newScan.id }, '${ newScan.type }', '${ newScan.value }' )"
    ); 

    return resp;
  }

  newScan(ScanModel newScan) async {
      final db = await database;

      final resp = await db.insert('Scans', newScan.toJson());

      return resp;
  }

  // SELECT - GET INFO

  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id] );

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null ;

  }

  Future<List<ScanModel>> getAllScans() async { 

    final db = await database;

    final resp = await db.query('Scans');

    List<ScanModel> list = resp.isNotEmpty 
                          ? resp.map( (c) => ScanModel.fromJson(c) ).toList()
                          : [];
    return list;                      

  }

  Future<List<ScanModel>> getAllScansForType( String type) async { 

    final db = await database;

    final resp = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");

    List<ScanModel> list = resp.isNotEmpty 
                          ? resp.map( (c) => ScanModel.fromJson(c) ).toList()
                          : [];
    return list;                      

  }

  // UPDATE REGISTER
  
  updateScan(ScanModel updateScan) async {
    final db = await database;

    final resp = await db.update('Scans', updateScan.toJson(), where: 'id = ?', whereArgs: [updateScan.id]  );

    return resp;

  }

  // DELETE REGISTER

  Future<int> deleteScan(int id) async {

    final db = await database;

    final resp = await db.delete('Scans', where: 'id=?', whereArgs: [id] );

    return resp;
  }

  deleteAllScan() async {

    final db = await database;

    final resp = await db.rawDelete('DELETE FROM Scans');

    return resp;
  }


}
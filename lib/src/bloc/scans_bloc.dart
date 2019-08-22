import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';



class ScansBloc with Validators{

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    // OBTENER SCANS DE LA BASE DE DATOS
    obtainAllScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream  => _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validateHttp);


  dispose(){
    _scansController?.close();
  }

  obtainAllScans() async {

    _scansController.sink.add( await DBProvider.db.getAllScans() );

  }

  addScan( ScanModel scan ) async {
    await DBProvider.db.newScan(scan);
    obtainAllScans();
  }

  deleteScan(int id) async {

    await DBProvider.db.deleteScan(id);
    obtainAllScans();

  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScan();
    _scansController.sink.add([]);
  }
  
}
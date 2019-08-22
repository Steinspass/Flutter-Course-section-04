import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';
import 'package:qrreaderapp/src/utils/util.dart' as util;

import 'package:qrcode_reader/qrcode_reader.dart';

class HomePage extends StatefulWidget {
  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
      ),
      body: _loadingPage(currentIndex),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _createBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
         currentIndex = index; 
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Maps')
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          title: Text('Directions')
          ),  
      ],
    );

  }

  Widget _loadingPage(int pagePosition) {

    switch( pagePosition ) {

      case 0: return MapsPage();
      case 1: return DirectionsPage();

      default: return MapsPage();
    }

  }


  _scanQR(BuildContext context) async {

    // https://bunkalist.com
    // geo:35.72965135483401,139.77701768437498

    String futureString;

    try{
      futureString = await new QRCodeReader().scan();
    }catch(e){
      futureString = e.toString();
    }

    if(futureString != null){

      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);


      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750 ), (){
            util.openScans(context, scan);
        });
      }else{
          Future.delayed(Duration(milliseconds: 750 ), (){
            util.openScans(context, scan);
        });
      }

    }
  }

  



}
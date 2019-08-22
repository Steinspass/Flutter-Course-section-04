import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/util.dart' as util;



class MapsPage extends StatelessWidget {
  
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtainAllScans();

    return  StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }

        final scans = snapshot.data;

        if(scans.length == 0){
          return Center(
            child: Text('no info'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.redAccent,),
            onDismissed: (direction) => scansBloc.deleteScan(scans[i].id),
            child: ListTile(
              onTap: () => util.openScans(context, scans[i]),
              leading: Icon(Icons.map, color: Theme.of(context).primaryColor,),
              title: Text(scans[i].value),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blueGrey,),
            ),
          ),
        );

      },
    );
  }
}
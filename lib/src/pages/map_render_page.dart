import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';


class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController map = new MapController();

  String typeMap = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text('QR coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 10);
            },
          ),
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFAB(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10
      ),
      layers: [
        _createMap(),
        _createPoint( scan )
      ],
    );
  }

  _createMap(){
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/' 
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
          'accessToken' : 'pk.eyJ1Ijoic3RlaW5zcGFzcyIsImEiOiJjanptbjdwcTQwZHN4M2pwYjdpMzNoMjFoIn0.-W0ldL9YpkaU6N4qk-06XA',
          'id' : 'mapbox.$typeMap' // streets, dark, light, outdoors, satellite
      }
    );
  }

  _createPoint(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on,
               size: 60.0,
               color: Theme.of(context).primaryColor,
               ),
          )
        )
      ]
    );
  }

  Widget _createFAB(BuildContext context) {
      return FloatingActionButton(
        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          // streets, dark, light, outdoors, satellite
          if(typeMap == 'streets'){
            typeMap = 'dark';
          }else if(typeMap == 'dark'){
            typeMap = 'light';
          }else if(typeMap == 'light'){
            typeMap = 'outdoors';
          }else if(typeMap == 'outdoors'){
            typeMap = 'satellite';
          }else{
            typeMap = 'streets';
          }

          setState(() {});

        },
      );
  }  
}
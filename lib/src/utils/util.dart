import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';
import 'package:url_launcher/url_launcher.dart';

openScans(BuildContext context, ScanModel scan) async{
  
  if(scan.type == 'http'){
    
    if(await canLaunch(scan.value)){
      await launch(scan.value);
    }else{
      throw 'Could not launch ${ scan.value }';
    }
  }else{
      Navigator.pushNamed(context, 'map', arguments: scan);
  }




  
}
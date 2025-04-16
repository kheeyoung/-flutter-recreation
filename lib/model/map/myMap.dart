import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/mapDTO.dart';
import 'package:myapp/model/map/mapViewer.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/mapService.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Header header = Header();
  MapService ms = MapService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header.screenHeader(context, "MAP"),
        body: FutureBuilder(
            future: ms.getMapImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              print("MyMap 호출");

              if (snapshot.hasData) {
                return Mapviewer(snapshot.data);
              }
              return const Center(
                child: Text("조사를 위한 준비중..."),
              );
            })
    );
  }
}

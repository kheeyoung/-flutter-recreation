import 'package:flutter/material.dart';
import 'package:myapp/screens/detailedMap.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Header header=Header();
  MyNotification myNotification=MyNotification();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.screenHeader(context, "MAP"),
      body: Center(
        child: Column(
          children: [
            //1층
            OutlinedButton(
                onPressed: (){
                  myNotification.DialogToCheck(context, 1, Detailedmap(floor: 1));
                },
                child: Text("A 구역")
            ),
            //2층
            OutlinedButton(
                onPressed: (){
                  myNotification.DialogToCheck(context, 2, Detailedmap(floor: 2));
                },
                child: Text("B 구역")
            ),
            //3층
            OutlinedButton(
                onPressed: (){
                  myNotification.DialogToCheck(context, 3, Detailedmap(floor: 3));
                },
                child: Text("C 구역")
            ),
            //4층
            OutlinedButton(
                onPressed: (){
                  myNotification.DialogToCheck(context, 4, Detailedmap(floor: 4));
                },
                child: Text("D 구역")
            ),
            //5층
            OutlinedButton(
                onPressed: (){
                  myNotification.DialogToCheck(context, 5, Detailedmap(floor: 5));
                },
                child: Text("E 구역")
            )

          ],
        ),
      ),
    );
  }
}

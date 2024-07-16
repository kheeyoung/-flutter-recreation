import 'package:flutter/material.dart';
import 'package:myapp/screens/detailedMap.dart';
import 'package:myapp/widget/header.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Header header=Header();
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
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const Detailedmap(floor: 1);
                      }));
                },
                child: Text("1층")
            ),
            //2층
            OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const Detailedmap(floor: 2);
                      }));
                },
                child: Text("2층")
            ),
            //3층
            OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const Detailedmap(floor: 3);
                      }));
                },
                child: Text("3층")
            ),
            //4층
            OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const Detailedmap(floor: 4);
                      }));
                },
                child: Text("4층")
            ),
            //5층
            OutlinedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return const Detailedmap(floor: 5);
                      }));
                },
                child: Text("5층")
            )

          ],
        ),
      ),
    );
  }
}

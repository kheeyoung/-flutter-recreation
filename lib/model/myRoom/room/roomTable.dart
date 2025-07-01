import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/service/roomService.dart';

class Roomtable extends StatefulWidget {
  const Roomtable({super.key});

  @override
  State<Roomtable> createState() => _RoomtableState();
}

class _RoomtableState extends State<Roomtable> {
  final _authentication = FirebaseAuth.instance;
  RoomService rs = RoomService();

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double iconSize = fullWidth * 0.18;
    final user = _authentication.currentUser;
    return FutureBuilder(
        future: Future.wait([rs.getRoomTable(),rs.checkMyRoom(user!.uid)]),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            List<Widget> table = rs.makeRoomMap(snapshot.data[0],iconSize, context,user!.uid );
            List<Widget> w=[
              Text("개인실", style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Column(
                    children: table),
              )
            ];

            if(! snapshot.data[1]){
              w.add(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: ()async{

                      await rs.makeRoom(user!.uid);

                      setState(() {

                      });

                    },
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        Text("짐 풀기")
                      ],
                    ),
                  )
                ],
              ));
            }

            return Column(
              children: w,
            );

          }
          return Text("Loading...");

    });
  }
}

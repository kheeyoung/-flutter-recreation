import 'package:flutter/material.dart';
import 'package:myapp/DTO/myMap/mapPointDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';

class Lock extends StatefulWidget {
  const Lock({super.key, required this.pw, required this.mmd});
  final String pw;
  final MapPointDTO mmd;

  @override
  State<Lock> createState() => _LockState();
}

class _LockState extends State<Lock> {
  @override
  Widget build(BuildContext context) {
    MyNotification mn = MyNotification();
    String pw="";
    return Column(
      children: [
        Text("enter password"),
        SizedBox(
          width: 200,
          child: TextFormField(
              key: ValueKey(1),
              onSaved: (value) {
                pw = value!;
              },
              onChanged: (value) {
                pw = value;
              },
          ),
        ),
        OutlinedButton(onPressed: (){
          if(pw==widget.pw){

          }
          else{

          }
        }, child: Text("확인"))
      ],
    );
  }
}

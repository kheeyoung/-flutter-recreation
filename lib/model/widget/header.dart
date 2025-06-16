import 'package:flutter/material.dart';
import 'package:myapp/model/login.dart';
import 'package:myapp/model/widget/myNotification.dart';
import '../alarm.dart';


class Header {
  MyNotification mn = MyNotification();
  AppBar screenHeader(context,text) {
    return AppBar(
      backgroundColor: Colors.transparent, //appBar 투명색
      title: Text(text),
      centerTitle: true,

    );
  }

  AppBar basicHeader(context,text,authentication){
    return AppBar(
      title: Text(text,style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.black45,

      actions: [

        IconButton(
            onPressed: (){

              Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => Alarm())));
            },
            icon: const Icon(
              Icons.access_alarm,
              color: Colors.black54,
            )
        ),
        IconButton(
            onPressed: (){
              mn.logout(context,authentication);

            },
            icon: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.black54,
            )
        ),
      ],
    );
  }


}

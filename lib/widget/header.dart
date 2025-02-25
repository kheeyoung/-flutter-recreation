import 'package:flutter/material.dart';
import 'package:myapp/screens/login.dart';

import '../screens/alarm.dart';

class Header {
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
      backgroundColor: Colors.white,

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
              authentication.signOut();  //로그아웃
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: ((context) => Login())));
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

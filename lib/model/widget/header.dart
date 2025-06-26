import 'package:flutter/material.dart';
import 'package:myapp/model/login.dart';
import 'package:myapp/model/widget/myNotification.dart';
import '../alarm.dart';
import '../myRoom/doc/makeDoc/makeDoc.dart';


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

  AppBar NotHeader(context,text,content){
    return AppBar(
      title: Text(text,style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,

      actions: [
        IconButton(
            onPressed:  () => mn.DialogBasic(context, content),
            icon: const Icon(
              Icons.question_mark,
              color: Colors.black54,
            )
        ),
      ],
    );
  }

  AppBar DocEditHeader(context,text){
    return AppBar(
      title: Text(text,style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,

      actions: [
        IconButton(
            onPressed:  () => {
            Navigator.push(context, MaterialPageRoute(
            builder: (context){
            return Makedoc();
            }))
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black54,
            )
        ),
      ],
    );
  }

}

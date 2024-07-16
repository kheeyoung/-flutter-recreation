import 'package:flutter/material.dart';
import 'package:myapp/screens/login.dart';

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
      backgroundColor: Colors.black54,

      actions: [
        IconButton(
            onPressed: (){
              authentication.signOut();  //로그아웃
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: ((context) => Login())));
            },
            icon: const Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            )
        )
      ],
    );
  }
}

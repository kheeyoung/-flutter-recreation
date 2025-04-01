import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/menu.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';

import '../service/ectMethod.dart';
import '../service/keyMethod.dart';


class Notok extends StatefulWidget {
  final String ExitKey;

  const Notok({super.key, required this.ExitKey});

  @override
  State<Notok> createState() => _NotokState();
}

class _NotokState extends State<Notok> {
  final _authentication = FirebaseAuth.instance;
  Header header = Header();
  MyNotification myNotification = MyNotification();
  Keymethod key = Keymethod();
  Ectmethod ect = Ectmethod();

  @override
  Widget build(BuildContext context) {
    String K= widget.ExitKey;
    return FutureBuilder(
        future: Future.wait([ect.getImage()]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            String image = snapshot.data[0] != null ? snapshot.data[0] : "";
            Widget ImageView = Image.network(image);
            return Scaffold(
                backgroundColor: Colors.black87,
                body:
                GestureDetector(
                    onTap: () {
                      myNotification.DialogToCheckIsOK(
                          context, K, Menu());
                    },
                    child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ImageView,
                            ],
                          ),
                        ))
                )
            );


          }
          else {
            return Scaffold(
              body: Text("로딩중"),
            );
          }
        }
    );
  }
}




import 'package:flutter/material.dart';
import 'package:myapp/model/myMap/research.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/myMapService.dart';


class Mymap extends StatefulWidget {

  const Mymap({super.key});

  @override
  State<Mymap> createState() => _MymapState();
}

class _MymapState extends State<Mymap> {
  Header header = Header();
  MyNotification mn = MyNotification();


  @override
  Widget build(BuildContext context) {
    String pw="";
    MyMapService mms= MyMapService();
    MyNotification mn = MyNotification();
    return Scaffold(
      appBar: header.NotHeader(
          context, "MAP", "조사 중 발견한 비밀번호로 잠긴 구역과 다른 사람의 개인실을 들어갈 수도 있습니다."),
      body:  FutureBuilder(
          future: mms.getMapSetting(),

          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.isLock){

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock),

                      ],
                    ),

                    SizedBox(
                      width: 200,
                      child: TextFormField(
                          obscureText: true,
                          //입력하는 값 안보이게 하기
                          key: ValueKey(1),
                          onSaved: (value) {
                            pw = value!;
                          },
                          onChanged: (value) {
                            pw = value;
                          },
                      ),
                    ),

                    IconButton(
                      onPressed: () async{
                        if(snapshot.data.pw==pw){
                          Navigator.push(context, MaterialPageRoute(    //다음창으로 이동
                              builder: (context){
                                return Research(mmd: snapshot.data);
                              }));
                        }
                        else{
                          mn.DialogBasic(context, "비밀번호가 옳지 않습니다.");
                        }
                      },
                      icon: const Icon(Icons.key),
                    ),
                  ],
                );
              }else{
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Research(mmd: snapshot.data)));
                });
              }
            }
            return Text("Loading...");
          }),
    );
  }
}

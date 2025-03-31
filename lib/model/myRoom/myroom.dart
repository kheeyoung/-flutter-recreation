import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/myRoom/bank/bank.dart';
import 'package:myapp/model/myRoom/item.dart';
import 'package:myapp/service/weatherService.dart';
import '../../service/boardMethod.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/myNotification.dart';
import 'likePoint.dart';

class Myroom extends StatefulWidget {
  const Myroom({super.key});

  @override
  State<Myroom> createState() => _MyroomState();
}

class _MyroomState extends State<Myroom> {
  Usermethod usermethod = new Usermethod();
  final _authentication = FirebaseAuth.instance;
  MyNotification myNotification =MyNotification();
  Header header=Header();
  Boardmethod boardmethod=Boardmethod();
  Weatherservice ws = Weatherservice();

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.screenHeader(context, "MY ROOM"),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder(future: ws.getWeather(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData){
                      return Text(snapshot.data.temp.toString());
                    }
                    return Text("loading...");
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //호감도 버튼
                      Column(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    return const Likepoint();
                                  }));
                            },
                            icon: Icon(Icons.favorite_outlined,size: 80,),tooltip: "호감도",),
                          Text("호감도")
                        ],
                      ),
                      SizedBox(width: 20,),
                      //아이템
                      Column(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context){
                                    return Item();
                                  }));
                            },
                            icon: Icon(Icons.shopping_bag_rounded,size: 80,),tooltip: "아이템",),
                          Text("아이템")
                        ],
                      ),
                      SizedBox(width: 20,),
                      //송금
                      Column(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(    //가챠창으로 이동
                                  builder: (context){
                                    return const Bank();
                                  }));
                            },
                            icon: Icon(Icons.monetization_on_sharp,size: 80,),tooltip: "은행",),
                          Text("은행")
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ));
  }


}

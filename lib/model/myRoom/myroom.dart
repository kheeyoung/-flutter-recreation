import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/myRoom/bank/bank.dart';
import 'package:myapp/model/myRoom/item.dart';
import 'package:myapp/model/myRoom/myPet.dart';
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
  MyNotification myNotification =MyNotification();
  Header header=Header();
  Boardmethod boardmethod=Boardmethod();
  Weatherservice ws = Weatherservice();


  @override
  Widget build(BuildContext context) {
    double fullWidth =MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: header.screenHeader(context, "MY ROOM"),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: fullWidth*0.9,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder(future: ws.getWeather(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData){

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text("Weather", style: TextStyle(fontSize: 18)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(children: [

                                  Text(snapshot.data.description.toString()),
                                  ws.getIcons(snapshot.data.icon,50)

                                ]),
                                Column(children: [
                                  Text("Tem"),
                                  Text("${snapshot.data.temp}ºC", style: TextStyle(fontSize: 25)),
                                ]),
                                Column(children: [
                                  Text("Hum"),
                                  Text("${snapshot.data.humidity}%", style: TextStyle(fontSize: 25)),
                                ]),
                              ],
                            ),

                            SizedBox(height: 2,
                              child: Divider(),),
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
                                        icon: Icon(Icons.favorite_outlined,size: 60,),tooltip: "호감도"),
                                    Text("호감도")
                                  ],
                                ),
                                SizedBox(width: 10,),
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
                                        icon: Icon(Icons.shopping_bag_rounded,size: 60,),tooltip: "아이템"),
                                    Text("아이템")
                                  ],
                                ),
                                SizedBox(width: 10,),
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
                                      icon: Icon(Icons.monetization_on_sharp,size: 60,),tooltip: "은행",),
                                    Text("은행")
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            SizedBox(height: 2,
                              child: Divider(),),
                            SizedBox(height: 10,),
                            Mypet()
                          ],
                        ),
                      );
                    }
                    return Text("마이룸으로 이동중...");
                      }),


                ],
              ),
            ),
          ),
        ));
  }


}

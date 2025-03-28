import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/userMethod.dart';
import 'myNotification.dart';


class ListViewWidget{
  MyNotification mn = MyNotification();
  InputTextFormField itff = InputTextFormField();
  Usermethod um = Usermethod();
  CoinService cs = CoinService();


  Future<List<Widget>> showUserCoinAndLike (width, context) async{

    Map<String,String> user = await um.getUser();
    Map<String,int> coin = await cs.getAllCoin();

    List<Widget> coinList = [];
    for (String name in user.keys) {

      String userUid = user[name]!;

      int userCoin = coin[userUid]==null ? 0 : coin[userUid]!.toInt();


      coinList.add(Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: width*0.7,
                    child: Text(name)),
                SizedBox(
                    width: width*0.2,
                    child:Text(userCoin.toString())),
                SizedBox(
                  width: width*0.1,
                  child: GestureDetector(
                    onTap: (){
                      mn.DialogToShowLikePoint(context, name,userUid);
                    },
                      child: Icon(Icons.monitor_heart, size: 25,)
                  ),
                )
              ],
            ),
            const SizedBox(width: 300, child: Divider()),
          ],
        ),
      ));
    }
    return coinList;
  }

  Widget showBank (List<Inquirydto> data, context, sort){
    if(sort){
      data.sort((a, b) => a.date.compareTo(b.date));
    }
    else{
      data.sort((a, b) => b.date.compareTo(a.date));
    }

    List<Widget> coinList = [];
    for (Inquirydto i in data) {
      Color c = i.input>0? Colors.red :Colors.blue;
      String s = i.input>0? "입금" : "출금";
      coinList.add(
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${i.date} | ${i.from}", style: TextStyle(fontSize: 10),),
                    Text(i.memo, style: TextStyle(fontSize: 20),)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(s,
                        style: TextStyle(
                            fontSize: 10,
                            color: c
                        )
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
            
                      children: [
                        Text(i.input.toString(),
                            style: TextStyle(
                                fontSize: 30,
                              color: c
                            )
                        ),
                        SizedBox(width: 5,),
                        Text("coin",
                            style: TextStyle(
                                fontSize: 10,
                                color: c
                            ))
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
      );
      coinList.add(SizedBox(width: MediaQuery.of(context).size.width ,
          child: const Divider(color: Colors.black,)),);
    }
    return Column(children: coinList);
  }




}
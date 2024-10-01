import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widget/myNotification.dart';

class ListViewWidget{
  MyNotification mn = MyNotification();
  List<Widget> showUserCoinAndLike (userCoinData, context){
    List<Widget> coinList = [];
    for (int i = 0; i < userCoinData.length; i++) {

      coinList.add(Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 180,
                    child: Text(userCoinData[i][0].toString())),
                SizedBox(
                    width: 50,
                    child:Text(userCoinData[i][2].toString())),
                SizedBox(
                  width: 30,
                  child: GestureDetector(
                    onTap: (){
                      mn.DialogToShowLikePoint(context, userCoinData[i][1],userCoinData[i][0]);
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


}
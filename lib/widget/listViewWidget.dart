import 'package:flutter/material.dart';

class ListViewWidget{
  List<Widget> showUserCoin (userCoinData){
    List<Widget> coinList = [];
    for (int i = 0; i < userCoinData.length; i++) {
      coinList.add(Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    child: Text(userCoinData[i][0].toString())),
                SizedBox(
                    width: 50,
                    child:Text(userCoinData[i][1].toString())),
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
import 'package:flutter/material.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/widget/myNotification.dart';

class PostViewWidget {
  Boardmethod boardmethod = new Boardmethod();
  Usermethod usermethod = new Usermethod();
  MyNotification myNotification=MyNotification();

  Widget PostView(postviewer, userUid) {
    if (postviewer == false) {
      return PostViewer(boardmethod.getBoard());
    } else {
      return PostViewer(boardmethod.getMyBoard(userUid));
    }
  }

  Widget PostViewer(method) {
    return FutureBuilder(
      future: method,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data;
          int totalNum = posts.length;
          print(totalNum);

          List<DataRow> postList = [];
          int no = 0;

          for (int i = 0; i < totalNum; i++) {
            no = i + 1;

            //현재 시간과 비교하여 얼마나 오래 전에 올라온 글인지 확인하기
            String time=boardmethod.getDifferTime(snapshot.data[i].getPostUid());

            //제목이 너무 길면 자르기
            String title = snapshot.data[i].getTitle();
            if (title.length > 8) {
              title = title.substring(0, 8) + "...";
            }
            //이름
            String name = snapshot.data[i].getRecipientName();

            //오늘 올라온 글에는 뉴 딱지 붙이기
            String isNew="";
            if(time.contains("분")||time.contains(("시"))){
              isNew="● ";
            }
            postList.add(DataRow(
                onSelectChanged: (newValue) {
                  myNotification.DialogToPost(context,snapshot.data[i]);

                },
                cells: [
                  DataCell(Text(no.toString())),
                  DataCell(Row(children: [Text(isNew,style: TextStyle(color: Colors.red,fontSize: 10),),Text(title)],)),
                  DataCell(Text(name)),
                  DataCell(Text(time))
                ]));
          }

          return DataTable(
            showCheckboxColumn: false,
            horizontalMargin: 12.0,
            columnSpacing: 10.0,
            columns: const [
              DataColumn(label: Text("no",style: TextStyle(fontWeight: FontWeight.bold),)),
              DataColumn(label: Text('title',style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('수신인',style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('게시일',style: TextStyle(fontWeight: FontWeight.bold)))
            ],
            rows: postList,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("로딩중");
        } else {
          return Text("오류!");
        }
      },
    );
  }
}

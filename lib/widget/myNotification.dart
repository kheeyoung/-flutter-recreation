
import 'package:flutter/material.dart';
import 'package:myapp/method/boardMethod.dart';
import 'package:myapp/method/keyMethod.dart';
import 'package:myapp/method/userMethod.dart';
import 'package:myapp/screens/masterPage.dart';
import 'package:myapp/widget/inputTextFormField.dart';


class MyNotification{
  Boardmethod boardmethod=Boardmethod();
  InputTextFormField inputTextFormField=InputTextFormField();
  Keymethod keymethod=Keymethod();
  Usermethod user= Usermethod();

  SnackbarBasic(context,textContents){
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(textContents),
            backgroundColor: Colors.black54)
    );
  }

  DialogwithImage(context,giftUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(giftUrl,
                width: 300,
                height:300,
                fit: BoxFit.cover,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      },
    );
  }

  DialogBasic(context,text) {
    showDialog(

      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text(text),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      },
    );
  }

  DialogToPost(context,post) {
    List Postdate=boardmethod.convertDate(post.getPostUid());
    showDialog(
      context: context,
      builder: (context) {
        print(Postdate);
        return
          Dialog(
            child: Container(
              height: 450,
              margin: EdgeInsets.fromLTRB(20,20,20,20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Center(child: Text(post.getTitle(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                        Divider(color: Colors.black, thickness: 1.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("수신인 : "+post.getRecipientName()),
                            Text("선물    : "+post.getGiftName()),
                            Text("송신일 : "+Postdate[1]+"/"+Postdate[2]+" "+Postdate[3]+":"+Postdate[4]+" "+Postdate[5]),
                            Divider(color: Colors.black, thickness: 1.0),
                            Text(post.getContents()),
                          ],
                        )

                      ],
                    ),
                  ),

                  Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  )
                ],

              ),
                    ),
          );
      },
    );
  }

  DialogToCheck(context,keyType,screen){
    String pw="";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text("PW?"),
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
                    decoration: inputTextFormField.basicFormDeco("Password를 입력해주세요.")
                ),
              ),
              IconButton(
                onPressed: () async{
                  if(await keymethod.checkMaster(pw,keyType)==true){
                    Navigator.push(context, MaterialPageRoute(    //다음창으로 이동
                        builder: (context){
                          return screen;
                        }));
                  }
                  else{
                    DialogBasic(context, "비밀번호가 옳지 않습니다.");
                  }
                },
                icon: const Icon(Icons.key),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      },
    );
  }


  DialogToCheckIsOK(context,key,screen){
    String pw="";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.accessibility),
                  Icon(Icons.accessibility),
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
                    decoration: inputTextFormField.basicFormDeco("Password를 입력해주세요.")
                ),
              ),
              IconButton(
                onPressed: () async{
                  if(key==pw){
                    Navigator.push(context, MaterialPageRoute(    //다음창으로 이동
                        builder: (context){
                          return screen;
                        }));
                  }
                  else{
                    DialogBasic(context, "비밀번호가 옳지 않습니다.");
                  }
                },
                icon: const Icon(Icons.key),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        );
      },
    );
  }

  DialogToShowLikePoint(context,userUid, userCoinData) {
    showDialog(
      context: context,
      builder: (context) {

        return FutureBuilder(
          future: Future.wait([user.getMyLikePoint(userUid)]),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              List data =snapshot.data[0];
              List<DataRow> datacelldata=[];
              for(int i=0; i<data.length; i++){
                //호감도
                int likenum=data[i][2];
                //상대 이름
                String name= data[i][1];
                datacelldata.add(
                    DataRow(cells: [
                      DataCell(Text(name)),
                      DataCell(Text(likenum.toString())),

                    ])
                );
              }

              return Dialog(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15,),
                      Text("$userCoinData의 호감도 현황"),
                      SizedBox(height: 15,),
                      DataTable(
                          columns: const [
                            DataColumn(label: Text("이름")),
                            DataColumn(label: Text("호감도")),

                          ],
                          rows: datacelldata
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                )
              );
            }
            else{
              return Text("로딩중");
            }
          }

        );
      },
    );
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myapp/DTO/wikiDTO/sectionDTO.dart';

import 'package:myapp/service/wikiService.dart';
import '../../service/boardMethod.dart';
import '../../service/keyMethod.dart';
import '../../service/userMethod.dart';
import '../login.dart';
import 'inputTextFormField.dart';



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
                    child: SingleChildScrollView(
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

  DialogToShowLikePoint(context,name, uid) {
    showDialog(
      context: context,
      builder: (context) {

        return FutureBuilder(
          future: Future.wait([user.getMyLikePoint(uid)]),
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
                      Text("$name의 호감도 현황"),
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

  void DialogToAlarm(BuildContext context, data) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15,),
                Text(data.title),
                Divider(color: Colors.black,),
                Text("날짜 : "+data.date),
                Divider(color: Colors.black,),
                Text(data.contents),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void DialogInfo(BuildContext context, List<String> text) {
    List<Widget> w = [];
    w.add(Text("개인정보 이용동의", style: TextStyle(fontSize: 20),));
    for(String s in text){
      w.add(SizedBox(height: 15,));
      w.add(Text(s,style: TextStyle(fontSize: 10)));
    }
    w.add(IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.close),
    ));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(

          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: w,
              ),
            ),
          ),
        );
      },
    );
  }

  void DialogGacha(BuildContext context, List gift) {
    Map<String,int> myItmeList=Map<String,int>();
    List<Widget> w =[];
    for(int i=0; i<gift.length; i++){
      if(myItmeList.containsKey(gift[i][0])){
        myItmeList[gift[i][0]]=(myItmeList[gift[i][0]]!+1);

      }
      else{myItmeList[gift[i][0]]=1;}
    }
    

    w.add(Text("<결과>"));
    for(String s in myItmeList.keys){
      w.add(Text("$s : ${myItmeList[s]}개"));
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(

          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: w,
              ),
            ),
          ),
        );
      },
    );
  }

  void logout(context,authentication) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("로그아웃 하시겠습니까?"),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: (){
                        authentication.signOut();  //로그아웃
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: ((context) => Login())));
                      }, child: Text("Yes"), ),
                      SizedBox(width: 10,),
                      OutlinedButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("No"), )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      },
    );

  }



  void wigetListDialog(List<Widget> w , context) {
    showDialog(
      context: context,
      builder: (context) {


        return Dialog(
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: w
              ),
            ),
          ),
        );
      },
    );
  }

  void DialogDelete(BuildContext context, SectionDto currentSd, String uid, String public) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("삭제 하시겠습니까?"),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: () async {
                        final db = FirebaseFirestore.instance;
                        db.collection("wiki").doc(uid).collection(public).doc("document").collection("doc").doc(currentSd.id).delete().then(
                              (doc) => {},
                          onError: (e) => print("Error updating document $e"),
                        );
                        Navigator.of(context).pop();
                      }, child: Text("Yes"), ),
                      SizedBox(width: 10,),
                      OutlinedButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text("No"), )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 클릭 못하게
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

}
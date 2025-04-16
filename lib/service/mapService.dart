import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/mapDTO.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';

class MapService {
  InputTextFormField itff =InputTextFormField();
  MyNotification mn = MyNotification();

  //맵 가져오기
  Future<MapDTO> getMap(List<String> nodePath) async {
    final db = FirebaseFirestore.instance;
    MapDTO result = MapDTO("", "", "", "", []);
    List<String> leaf = [];

    try {
      dynamic docRef = db.collection("map");

    if(nodePath.isNotEmpty) {
      //상위가 아닐 경우 문서 경로 구성
      for (int i = 0; i < nodePath.length - 1; i++) {
        if (i % 2 == 0) {
          docRef = docRef.doc(nodePath[i]); // 문서
        } else {
          docRef = docRef.collection(nodePath[i]); // 컬렉션
        }
      }

      //출력 문구 가져오기
      await docRef.get().then((querySnapshot) {
        result.image = querySnapshot.data()['image'].toString();
        result.txt = querySnapshot.data()['txt'].toString();
        result.node = querySnapshot.data()['node'].toString();
        result.lock = querySnapshot.data()['lock'].toString();
      }, onError: (e) => print("Error completing 출력 문구 가져오기: $e"),
      );

      docRef=docRef.collection(nodePath[nodePath.length-1]);
    }

      //조사 포인트 가져오기
      await docRef.get().then((querySnapshot) {
        Map<int, String> temp = {};
        int n=0;
        for (var docSnapshot in querySnapshot.docs) {
          int num = int.parse(docSnapshot.id);
          temp[num] = docSnapshot.data()['node'];
          n++;
        }

        for(int i=1; i<=n; i++){
          leaf.insert(i-1, temp[i].toString());
        }



      }, onError: (e) => print("Error completing: $e"));

      result.leafNode = leaf;

    } catch (e) {
      print("🔥 오류 발생: $e");
    }

    return result;
  }



  //현재 위치 보여주기
  showMyPos(List<String>node){
    String result="";
    for(String p in node){
      if( int.tryParse(p) == null){
        if(result!=""){result+= "> ";}
        result+= p;
      }

    }
    return result;
  }
  



  //맵 이미지 가져오기
  Future<Map<String,String>> getMapImage()async{
    Map<String,String> imageUrls={};
    final storageRef = FirebaseStorage.instance.ref().child("mapimage");
    try {
      // 'mapImage' 폴더 안의 모든 파일 목록 가져오기
      final ListResult result = await storageRef.listAll();

      // 각 파일에 대해 download URL 가져오기
      for (var item in result.items) {
        final url = await item.getDownloadURL();
        imageUrls[item.name] = url;

      }

    } catch (e) {
      print("🔥 Storage에서 이미지 가져오기 실패: $e");
    }

    return imageUrls;
  }



  //파일 가져오기
  Future<String?> getDownloadURL(String folderName, String fileName) async {
    try {
      // 파일 참조 생성
      Reference ref = FirebaseStorage.instance.ref().child('$folderName/$fileName');

      // 다운로드 URL 가져오기
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      // 파일이 존재하지 않거나 다른 오류가 발생한 경우 null 반환
      if (e is FirebaseException && e.code == 'object-not-found') {
        //print('파일이 존재하지 않습니다.');
      } else {
        //print('오류 발생: $e');
      }
      return null;
    }
  }



  //잠긴 구역 진입시 화면
showLockScreen(context,pass){
  String pw="";
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15,),
          Text("비밀번호를 입력하세요."),
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
                decoration: itff.basicFormDeco("Password를 입력해주세요.")
            ),
          ),
          IconButton(
            onPressed: () async{
              if(pw==pass){
                Navigator.pop(context);
              }
              else{
                mn.DialogBasic(context, "비밀번호가 옳지 않습니다.");
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
}

  Future<Map<String,String>>getTop()async {
    final db = FirebaseFirestore.instance;
    Map<String,String> result={};
    await db.collection("map").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        result[docSnapshot.data()['node'].toString()]= docSnapshot.id.toString();
      }
    }, onError: (e) => print("Error completing: $e"));

    return result;
  }

  Future<int> ChangePw(String newPassword, String selectedKey, String m) async{
    int result=0;

    try {
      final db = FirebaseFirestore.instance;
      await db.collection("map").doc(m).update({"lock":newPassword});
      result=1;
    }
    catch (e) {
      result=2;
    }
    return result;
  }








}

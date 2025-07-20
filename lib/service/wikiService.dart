import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:myapp/DTO/wikiDTO/profileDTO.dart';
import 'package:myapp/DTO/wikiDTO/sectionDTO.dart';
import 'package:myapp/DTO/wikiDTO/wikiDTO.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/model/myRoom/doc/characterPage.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../model/myRoom/doc/masterDoc.dart';


class WikiService {
  MyNotification mn = MyNotification();
  //wiki 리턴
  Future<List<WikiDto>> getWiki() async {
    final db = FirebaseFirestore.instance;
    List<WikiDto> wikiList = [];

    await db.collection("wiki").get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final dataMap = docSnapshot.data();

          WikiDto data = WikiDto(
            dataMap["name"] ?? "no data",
            dataMap["color"] ?? "000000",
            dataMap["talent"] ?? "no data",
            dataMap["uid"] ?? "no data",
            dataMap["fontColor"] ?? "000000",
            dataMap["private"] ?? false,
          );

          if (docSnapshot.id == "master") {
            wikiList.insert(0, data);
          } else {
            wikiList.add(data);
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return wikiList;
  }

  Future<WikiDto> getPersonalWiki(String uid) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("wiki").doc(uid);

    try {
      final doc = await docRef.get();

      if (doc.exists) {
        final dataMap = doc.data() ?? {};

        WikiDto data = WikiDto(
          dataMap["name"] ?? "no data",
          dataMap["color"] ?? "000000",
          dataMap["talent"] ?? "no data",
          dataMap["uid"] ?? "no data",
          dataMap["fontColor"] ?? "000000",
          dataMap["private"] ?? false,
        );

        return data;
      } else {
        print("문서가 존재하지 않음");
        return WikiDto("no data", "000000", "no data", "no data", "000000", false); // fallback
      }
    } catch (e) {
      print("Error getting document: $e");
      return WikiDto("no data", "000000", "no data", "no data", "000000", false); // error fallback
    }

  }


  makeIconList(List<WikiDto> data, iconSize, context) {

    List<Widget> iconList = [

    ];
    for (int i=0; i<data.length; i++) {
      String name=  data[i].name;
      int nameL =name.replaceAll(' ', '').replaceAll(".", '').length;
      String cutName = name.replaceFirst(" ", "\n");

      String talent = cutText(data[i].talent);
      String fontC = data[i].fontColor;


      iconList.add(GestureDetector(
        onTap: () {

          if(data[i].uid=="master"){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Masterdoc()),
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Characterpage(uid: data[i].uid)),
            );
          }
        },
        child: Center(
          child: Column(

            children: [
              Container(
                alignment: Alignment.center,
                width: i == 0 ? iconSize * 4 : iconSize,
                height: 30,
                color: colorFromHex(data[i].color),
                child: AutoSizeText(
                  talent,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorFromHex(fontC)),
                  maxLines: 1,
                  minFontSize: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  width: i==0 ? iconSize*4 : iconSize,
                  height: 50,
                  child: AutoSizeText(
                    nameL > 5 ? cutName: name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorFromHex(fontC)),
                    maxLines: 2,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                    wrapWords: false,
                  ),)


            ],
          ),
        ),
      ));
    }
    return iconList;
  }

  String cutText(String s){
    if(s.length>12){
      return "${s.substring(0,12)}...";
    }
    return s;
  }

  Color colorFromHex(String hexColor) {
    if(hexColor==""){hexColor="808080";}
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // 불투명도 기본값 FF 추가
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  makeTable(List<Widget> iconList, iconSize){
    List<Widget> colList = [
      iconList[0]
    ];

    List<Widget> rowList = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        rowList.add(iconList.length>i*4+j+1 ? iconList[i*4+j+1] :
        GestureDetector(
          onTap: () {
            print("none");
          },
          child: Container(
              width: iconSize,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: i==0 ? iconSize*4 : iconSize,
                      height: 30,
                      color: colorFromHex("666A73"),
                      child:  Center(child: Text("no data"))),

                  Container(
                      width: i==0 ? iconSize*4 : iconSize,
                      height: 50,
                      child: Center(child: Text("no data")))
                ],
              )),
        ));
      }
      colList.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowList));
      rowList=[];

    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: colList,);
  }

  Future<ProfileDTO> getProfile(String uid, String public) async {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("wiki").doc(uid).collection(public).doc("profile");
    print(uid);

    try {
      final doc = await docRef.get();
      if (doc.exists) {
        return ProfileDTO(
          doc["oneWord"],
          doc["name"],
          doc["originName"],
          doc["talent"],
          doc["bodyImage"],
          doc["awareness"],
          doc["age"],
          doc["birth"],
          doc["height"],
          doc["weight"],
          doc["relationship"],
          doc["belongings1"],
          doc["belongings2"],
          doc["belongings3"],
        );
      } else {
        print("문서 없음");
      }
    } catch (e) {
      print("에러 발생: $e");
    }

    // fallback
    return ProfileDTO("", "", "", "", "", "", "", "", "", "", "", "", "", "");
  }


  Future<void> saveBaisc(WikiDto wd, user, context)async {
    final db = FirebaseFirestore.instance;
    final docData = {
      "name": wd.name,
      "color": wd.color,
      "talent": wd.talent,
      "uid": user.uid,
      "fontColor" : wd.fontColor,
      "private": wd.private
    };

    db
        .collection("wiki")
        .doc(user.uid)
        .set(docData)
        .onError((e, _) => (){
          mn.SnackbarBasic(context, "오류 발생! 오류가 계속 될 경우 총괄계에 문의 주세요.");
          return;
        });
    mn.SnackbarBasic(context, "등록 성공!");

  }

  Future<void> saveProfile(ProfileDTO pd, String uid, String public, context) async{

    final db = FirebaseFirestore.instance;
    final docData = {
    "oneWord" : pd.oneWord,
    "name" : pd.name,
    "originName" : pd.originName,
    "talent" : pd.talent,
    "bodyImage" : pd.bodyImage,
    "awareness" :pd.awareness,
    "age":pd.age,
    "birth":pd.birth,
    "height":pd.height,
    "weight":pd.weight,
    "relationship":pd.relationship,
    "belongings1":pd.belongings1,
    "belongings2":pd.belongings2,
    "belongings3":pd.belongings3,
    };

    db.collection("wiki").doc(uid).collection(public).doc("profile").set(docData)
        .onError((e, _) => (){
      mn.SnackbarBasic(context, "오류 발생! 오류가 계속 될 경우 총괄계에 문의 주세요.");
      return;
    });
    mn.SnackbarBasic(context, "등록 성공!");
  }

  // 전신 이미지 가져오기
  Future<String> getImage(uid, public)async{
    var ref = FirebaseStorage.instance.ref().child('wikiImage/publicbody/${uid}.png');
    if(public != "public"){
      ref = FirebaseStorage.instance.ref().child('wikiImage/privatebody/${uid}.png');
    }
    String url = "";
    try{url = await ref.getDownloadURL();}
    catch(e){}

    return url;

  }

  Future<String> getForm(String uid, String public) async{
    var ref = FirebaseStorage.instance.ref().child('wikiImage/form/public/${uid}.png');
    if(public != "public"){
      ref = FirebaseStorage.instance.ref().child('wikiImage/form/private/${uid}.png');
    }
    String url="";
    try{
      url = await ref.getDownloadURL();
    }
    catch(e){}

    return url;
  }

  Future<List<SectionDto>> getPersonalDoc(String uid, String public) async {
    List<SectionDto> list = [];
    final db = FirebaseFirestore.instance;

    try {
      final documentRef = db.collection("wiki").doc(uid).collection(public).doc("document");

      // 1. sort 배열 가져오기
      final documentSnapshot = await documentRef.get();
      final sortList = List<String>.from(documentSnapshot.data()?["sort"] ?? []);

      // 2. doc 컬렉션 가져오기 (map으로 저장)
      final querySnapshot = await documentRef.collection("doc").get();
      final docMap = {
        for (var doc in querySnapshot.docs) doc.id: doc,
      };

      // 3. sort 배열 기준으로 정렬된 SectionDto 리스트 생성
      for (var id in sortList) {
        final docSnapshot = docMap[id];
        if (docSnapshot != null) {
          SectionDto data = SectionDto(
            docSnapshot["title"],
            docSnapshot["image"],
            docSnapshot["oneWord"],
            docSnapshot["content"],
            docSnapshot.id
          );
          list.add(data);
        }
      }
    } catch (e) {
      print("🔥 getPersonalDoc error: $e");
    }

    return list;
  }


  Future<void> addSection(SectionDto sd, String uid, String public) async {
    final db = FirebaseFirestore.instance;

    final docData = {
      "title": sd.title,
      "image": sd.image,
      "oneWord": sd.oneWord,
      "content": sd.content,
    };

    final documentRef = db.collection("wiki").doc(uid).collection(public).doc("document");
    final docCollectionRef = documentRef.collection("doc");

    try {
      // 1. 새 문서 추가 (자동 ID 생성)
      final newDocRef = await docCollectionRef.add(docData);
      final newDocId = newDocRef.id;

      // 2. document 문서 가져오기
      final documentSnapshot = await documentRef.get();

      List<String> sortList = [];

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null && data["sort"] != null) {
          sortList = List<String>.from(data["sort"]);
        }
      } else {
        // 🔥 문서가 없으면 새로 만듦
        await documentRef.set({"sort": []});
      }

      // 3. 새 ID를 맨 끝에 추가
      sortList.add(newDocId);

      // 4. 정렬 배열 업데이트
      await documentRef.update({"sort": sortList});
    } catch (e) {
      print("🔥 addSection 오류: $e");
    }
  }


  Future<void> saveSection(SectionDto sd, String uid, String public, context) async {

    final db = FirebaseFirestore.instance;

    final docData = {
      "title": sd.title,
      "image": sd.image,
      "oneWord": sd.oneWord,
      "content": sd.content,
    };

    try {
      await db
          .collection("wiki")
          .doc(uid)
          .collection(public)
          .doc("document")
          .collection("doc")
          .doc(sd.id) // 🔥 문서 ID 지정
          .set(docData); // set은 덮어쓰기 (업데이트처럼 작동)

      mn.SnackbarBasic(context, "등록 성공!");
    } catch (e) {
      print("🔥 saveSection 오류: $e");
      mn.SnackbarBasic(context, "오류 발생! 오류가 계속 될 경우 총괄계에 문의 주세요.");
    }
  }


  String extractImageName(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    String filename = path.split('/').last.split('%').elementAt(3).substring(2); // "1000013757.jpg"
    if(filename.length>15){
      filename=filename.substring(0,12)+"...";
    }

    return filename;
  }

  Future<void>makeWiki(String uid, String userName)async {
    final db = FirebaseFirestore.instance;
    final userdata = <String, dynamic>{
      "color": "ffffff",
      "name": userName,
      "private" : false,
      "talent" : "",
      "uid" : uid
    };
    await db.collection("wiki")
        .doc(uid)
        .set(userdata)
        .onError((e, _) => print("Error writing document: $e"));
  }





}

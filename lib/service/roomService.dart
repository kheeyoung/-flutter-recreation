import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/room/roomDTO.dart';
import 'package:myapp/DTO/room/roomItemDTO.dart';
import 'package:myapp/model/myRoom/room/personalRoom.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/userMethod.dart';

class RoomService {
  Usermethod um = Usermethod();
  MyNotification mn = MyNotification();

  Future<List<RoomDto>> getRoomTable() async {
    final db = FirebaseFirestore.instance;
    List<RoomDto> roomList = [];

    await db.collection("room").get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if(docSnapshot.id=="dummy"){continue;}
          RoomDto data = RoomDto(
            docSnapshot["uid"],
            docSnapshot["name"],
            docSnapshot["pw"],
            docSnapshot["pos"],
          );
          roomList.add(data);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    //정렬
    roomList.sort((a, b) => a.pos.compareTo(b.pos));

    return roomList;
  }

  List<Widget> makeRoomMap(data, iconSize, context, uid) {
    List<Widget> iconList = [];
    for (RoomDto r in data) {
      iconList.add(
        GestureDetector(
          onTap: () {
            if (uid == r.uid) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Personalroom(uid: uid, rd: r),
                  ));
            } else {
              mn.DialogToCheckIsOK(
                  context, r.pw, Personalroom(uid: r.uid, rd: r));
            }
          },
          child: Container(
            margin: EdgeInsets.all(1),
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.black, width: 1),
                    right: BorderSide(color: Colors.black, width: 1),
                    top: BorderSide(color: Colors.black, width: 1),
                    bottom: BorderSide(color: Colors.black, width: 1))),
            width: iconSize,
            height: 50,
            alignment: Alignment.center,
            child: Text(r.name),
          ),
        ),
      );
    }

    List<Widget> colList = [];

    for (int i = 0; i < 4; i++) {
      List<Widget> rowList = [];
      for (int j = 0; j < 4; j++) {
        int index = i * 4 + j;
        rowList.add(index < iconList.length
            ? iconList[index]
            : GestureDetector(
                onTap: () {
                  mn.SnackbarBasic(context, "아직 주인이 없는 방입니다.");
                },
                child: Container(
                  margin: EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          top: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1))),
                  width: iconSize,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("empty"),
                ),
              ));
      }
      colList.add(Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowList,
      ));
      colList.add(SizedBox(height: 20));
    }

    return colList;
  }


  Future<void> makeRoom(String uid) async {
    String name = await um.getUserNameByUid(uid);
    int num = await getRoomCount() + 1;
    final db = FirebaseFirestore.instance;

    List<String> docId=[];
    docId.add(await addItem(uid,
        RoomItemDto("", "침대", "푹신한 침대. 이 침대가 푹신한 이유는 푹신하기 때문이다.", false, []),));
    docId.add(await addItem(
        uid, RoomItemDto("", "테이블", "다양한 일을 할 수 있는 나무 테이블.", false, []),));
        docId.add(await addItem(
        uid, RoomItemDto("", "화장실", "혼자 만의 시간을 즐길 수 있는 화장실. 샤워부스와 양변기, 1인용 욕조가 있다.", false, []),));
    docId.add(await addItem(uid,
        RoomItemDto(
            "", "창문", "열차는 빠르게 달리고 있어서 창문 밖으로 고개를 내미는 건 위험하다", false, []),));
    final data = <String, dynamic>{
      "uid": uid,
      "name": name,
      "pw": "0000",
      "pos": num,
      "underPoint" : docId
    };
    await db
        .collection("room")
        .doc(uid)
        .set(data)
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<String> addItem(String uid, RoomItemDto rid) async {
    final db = FirebaseFirestore.instance;

    final docRef = db.collection("room").doc(uid).collection("item").doc(); // 문서 생성
    final data = <String, dynamic>{
      "id": docRef.id,
      "name": rid.name,
      "text": rid.text,
      "erasable": rid.erasable,
      "underPoint": rid.underPoint,
    };

    try {
      await docRef.set(data);
      print("Item '${rid.name}' added with ID: ${docRef.id}");
    } catch (e) {
      print("Error writing document: $e");
    }

    return docRef.id;
  }


  Future<int> getRoomCount() async {
    final collection = FirebaseFirestore.instance.collection("room");
    final aggregateQuery = collection.count();
    final aggregateQuerySnapshot = await aggregateQuery.get();
    return aggregateQuerySnapshot.count ?? 0;
  }

  Future<List<RoomItemDto>>getPersonalRoom(String uid, String id)async {
    List<RoomItemDto> result=[];
    try{
      List<String> point = await getUnderPoint(uid, id);

      for(String s in point){
        result.add(await getPoint(uid, s));

      }
    }catch(e){}

    return result;
  }

  Future<List<String>> getUnderPoint(String uid, String id)async{
    List<String> result=[];
    var docRef = FirebaseFirestore.instance.collection("room").doc(uid);

    if(id!=""){
      docRef =docRef.collection("item").doc(id);
    }

    try {
      await docRef.get().then((querySnapshot) {
        result=List<String>.from(querySnapshot.data()!["underPoint"] ??[]);

      });
    } catch (e) {
      print("오류 : $e");
    }
    return result;
  }

  Future<RoomItemDto> getPoint(String uid, String id)async{
    RoomItemDto result=RoomItemDto("", "", "", false, []);

    var docRef = FirebaseFirestore.instance.collection("room").doc(uid);
    if(id!=""){
    docRef = FirebaseFirestore.instance.collection("room").doc(uid).collection("item").doc(id);
    }

    try {
      await docRef.get().then((querySnapshot) {
        if(id==""){
          result.underPoint=List<String>.from(querySnapshot.data()!["underPoint"] ??[]);
          return result;
        }

        result.id=querySnapshot.data()!["id"];
        result.name=querySnapshot.data()!["name"];
        result.text=querySnapshot.data()!["text"];
        result.erasable=querySnapshot.data()!["erasable"];
        result.underPoint=List<String>.from(querySnapshot.data()!["underPoint"] ??[]);

      });
    } catch (e) {
      print("오류 : $e");
    }
    return result;
  }

  Future<String> getImage()async{
    try{
      final storageRef = FirebaseStorage.instance.ref();
      return await storageRef.child("myroom.png").getDownloadURL();
    }catch(e){return "";}

  }

  Future<void>savePoint(String uid, RoomItemDto myrid, context)async {
    final ref = FirebaseFirestore.instance.collection("room").doc(uid).collection("item").doc(myrid.id);
    ref.update({
      "name": myrid.name,
      "text" : myrid.text
    }).then(
            (value) => mn.SnackbarBasic(context, "저장 성공!"),
        onError: (e) => mn.SnackbarBasic(context, "저장 실패!"));
  }

  deletePoint(String uid, RoomItemDto myrid, String deleteId, BuildContext context) async{
    try{
      var ref = FirebaseFirestore.instance.collection("room").doc(uid);
      if(myrid.name!=""){
        ref=ref.collection("item").doc(myrid.id);
      }
      List<String> underPoint = myrid.underPoint;
      underPoint.remove(deleteId);
      ref.update({
        "underPoint": underPoint,
      });
      FirebaseFirestore.instance.collection("room").doc(uid).collection("item").doc(deleteId).delete();
      mn.SnackbarBasic(context, "삭제 성공!");
    }
    catch(e){
      print(e);
      mn.SnackbarBasic(context, "삭제 실패!");}
  }

  deleteTopPoint(String uid, String deleteId, BuildContext context) async{
    try{
      var ref = FirebaseFirestore.instance.collection("room").doc(uid);
      RoomItemDto rid =await getPoint(uid, "");

      List<String> underPoint = rid.underPoint;
      underPoint.remove(deleteId);
      ref.update({
        "underPoint": underPoint,
      });
      FirebaseFirestore.instance.collection("room").doc(uid).collection("item").doc(deleteId).delete();
      mn.SnackbarBasic(context, "삭제 성공!");
    }
    catch(e){
      print(e);
      mn.SnackbarBasic(context, "삭제 실패!");}
  }

  Future<List<RoomItemDto>>getUnderPointDTO(String uid, List<String> underPoint)async {
    List<RoomItemDto> result=[];
    for(String id in underPoint){
      result.add(await getPoint(uid, id));
    }
    return result;
  }

  Future<void>makeUnderPoint(String uid, RoomItemDto myrid, BuildContext context)async {
    try{
      String docId = await addItem(uid, RoomItemDto("", "하위 조사 포인트", "설명", true, []));
      final ref = FirebaseFirestore.instance.collection("room").doc(uid).collection("item").doc(myrid.id);
      List<String> underPoint = myrid.underPoint;
      underPoint.add(docId);
      ref.update({
        "underPoint": underPoint,
      });
    }catch(e){mn.SnackbarBasic(context, "추가 실패!");}
  }

  Future<RoomItemDto>makeUnderPointAtTop(String uid, BuildContext context) async{
    try{
      String docId = await addItem(uid, RoomItemDto("", "하위 조사 포인트", "설명", true, []));


      List<String> newUnderPoint = await getUnderPoint(uid, "");
      newUnderPoint.add(docId);
      FirebaseFirestore.instance.collection("room").doc(uid).update({
        "underPoint": newUnderPoint,
      });
      mn.SnackbarBasic(context, "추가 성공!");
      return RoomItemDto("", "하위 조사 포인트", "설명", true, []);

    }catch(e){mn.SnackbarBasic(context, "추가 실패!");}
    return RoomItemDto("", "", "", true, []);
  }

  Future<bool>checkMyRoom(String uid) async{
    final db = FirebaseFirestore.instance;
    bool result =false;
    final docRef = db.collection("room").doc(uid);
    await docRef.get().then(
          (DocumentSnapshot doc) {
        if (doc.exists ) {result = true;}
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return result;
  }

}

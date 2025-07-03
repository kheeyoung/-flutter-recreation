import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/DTO/myMap/mapPointDTO.dart';
import 'package:myapp/DTO/myMap/myMapDTO.dart';

class MyMapService{
  Future<MyMapDTO> getMapSetting()async{
    MyMapDTO result= MyMapDTO(true, "", [] );

    var docRef = FirebaseFirestore.instance.collection("map").doc("setting");

    try {
      await docRef.get().then((querySnapshot) {
        result.isLock=querySnapshot.data()!["isLock"];
        result.pw=querySnapshot.data()!["pw"];
        result.topNode=List<String>.from(querySnapshot.data()!["topNode"] ??[]);

      });
    } catch (e) {
      print("오류 : $e");
    }
    return result;
  }

  Future<MapPointDTO>getPoint(String uid)async {
    MapPointDTO result= MapPointDTO(uid, "", "", "", 0, "", [], "");
    if(uid.isEmpty){
      MyMapDTO mmd = await getMapSetting();
      result= MapPointDTO(uid, "", "", "", 0, "", mmd.topNode, "");

    }else{
      try {
        var docRef = FirebaseFirestore.instance.collection("map").doc("item").collection("item").doc(uid);
        await docRef.get().then((querySnapshot) {
          result.uid=querySnapshot.data()!["uid"].toString();
          result.text=querySnapshot.data()!["text"].toString();
          result.title=querySnapshot.data()!["title"].toString();
          result.lock=querySnapshot.data()!["lock"].toString();
          result.order=querySnapshot.data()!["order"];
          result.parent=querySnapshot.data()!["parent"].toString();
          result.image=querySnapshot.data()!["image"].toString();
          result.point=List<String>.from(querySnapshot.data()!["point"] ??[]);

        });
      } catch (e) {
        print("getPoint 오류 : $e");

      }
    }
    return result;
  }

  Future<String>getTitleByUid(String uid)async {
    String result="";
    var docRef = FirebaseFirestore.instance.collection("map").doc("item").collection("item").doc(uid);
    try {
      await docRef.get().then((querySnapshot) {
        result=querySnapshot.data()!["text"];
      });
    } catch (e) {
      print("오류 : $e");
    }
    return result;
  }

  Future<List<MapPointDTO>>getUnderPoints(String uid)async {
    MapPointDTO mpd =await getPoint(uid);
    List<String> underPoint = mpd.point;
    List<MapPointDTO> result=[];

    for(String id in underPoint){
      result.add(await getPoint(id));
    }
    //정렬
    result.sort((a, b) => a.order.compareTo(b.order));
    return result;
  }

  Future<String>getMapImage(String uid) async{
    if(uid.isEmpty){return "";}
    MapPointDTO mpd =await getPoint(uid);

    try{

      final storageRef = FirebaseStorage.instance.ref();
      return await storageRef.child("mapimage/${mpd.image}").getDownloadURL();
    }catch(e){return "";}
  }
}
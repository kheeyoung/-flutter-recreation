import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO//myMap.dart';


class Mapmethod {
  //컬랙션명(층수)로 정보 전부 가져오기
  Future<List<MyMap>> getMap(collectionName) async {
    final db = FirebaseFirestore.instance;
    List<MyMap> MapList = [];

    await db.collection(collectionName).get().then(
      (querySnapshot) {
        for (int i = 0; i < querySnapshot.size; i++) {

          MyMap data = MyMap(
              querySnapshot.docs[i]['Room'],
              querySnapshot.docs[i]['item1'],
              querySnapshot.docs[i]['item2'],
              querySnapshot.docs[i]['item3'],
              querySnapshot.docs[i]['item4'],
              querySnapshot.docs[i]['item5'],
              querySnapshot.docs[i]['txt'],)
        ;

          MapList.add(data);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    return MapList;
  }

  //조사용 맵 보기
  List<String> showMap(int level, String room, List<String>items, List mapList){
    List<String> maps=[];
    Set data= {};

    switch (level){
      case 0 :
        for(int i=0; i<mapList.length; i++){
          maps.add(mapList[i].getRoom());
        }
        break;

      case 1 :
        for(int i=0; i<mapList.length; i++){
          if(mapList[i].getRoom()==room &&mapList[i].getItem1()!=null){
            maps.add(mapList[i].getItem1());
          }
        }
        break;

      case 2 :
        for(int i=0; i<mapList.length; i++){
          if(mapList[i].getRoom()==room &&
              mapList[i].getItem1()==items[0] &&
              mapList[i].getItem2()!=null
          ){
            maps.add(mapList[i].getItem2());
          }
        }
        break;

      case 3 :
        for(int i=0; i<mapList.length; i++){
        if(mapList[i].getRoom()==room &&
            mapList[i].getItem1()==items[0] &&
            mapList[i].getItem2()==items[1] &&
            mapList[i].getItem3()!=null
        ){
          maps.add(mapList[i].getItem3());
        }
      }
        break;
      case 4 :
        for(int i=0; i<mapList.length; i++){
          if(mapList[i].getRoom()==room &&
              mapList[i].getItem1()==items[0] &&
              mapList[i].getItem2()==items[1] &&
              mapList[i].getItem3()==items[2] &&
              mapList[i].getItem4()!=null
          ){
            maps.add(mapList[i].getItem4());
          }
        }
        break;
      case 5 :
        for(int i=0; i<mapList.length; i++){
          if(mapList[i].getRoom()==room &&
              mapList[i].getItem1()==items[0] &&
              mapList[i].getItem2()==items[1] &&
              mapList[i].getItem3()==items[2] &&
              mapList[i].getItem4()==items[3] &&
              mapList[i].getItem5()!=null
          ){
            maps.add(mapList[i].getItem5());
          }
        }
        break;
    }

    //중복 되는 값 제거
    data=maps.toSet();
    maps=data.cast<String>().toList();
    //null값이 있으면 제거
    for(int i=0;i<maps.length; i++){
      if(maps[i]==""){maps.removeAt(i);}
    }
    maps.sort((a, b) => a.compareTo(b)); // 오름차순 정렬

    return maps;
  }

  String getMapTxt(level, room, items, mapList){
    String txt="";
    for(int i=0; i<mapList.length; i++){
      if(mapList[i].getRoom()==room &&
          mapList[i].getItem1()==items[0] &&
          mapList[i].getItem2()==items[1] &&
          mapList[i].getItem3()==items[2] &&
          mapList[i].getItem4()==items[3] &&
          mapList[i].getItem4()==items[4]
      ){
        txt= mapList[i].getTxt();
      }
    }
    return txt;
  }

  //열렸는지 확인(데이터가 있나)
  Future<bool> isOpend(collectionName) async {
    final db = FirebaseFirestore.instance;
    bool result=true;

    await db.collection(collectionName).get().then(
          (querySnapshot) {
        if(querySnapshot.size<=0){result=false;}
      },
      onError: (e) => print("Error completing: $e"),
    );

    return result;
  }

  //맵 이미지 가져오기
  Future<String> getMapImage(floorNum)async{
    final storageRef = FirebaseStorage.instance.ref();
    String result="";
    try {
      result = await storageRef.child("mapimage/map" + floorNum.toString() + ".png").getDownloadURL();

    }
    catch(e){}
    return result;
  }



}

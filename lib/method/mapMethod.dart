import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/DTO/myMap.dart';

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
          mapList[i].getItem5()==items[4]
      ){
        txt= mapList[i].getTxt();
      }
    }
    print(txt);
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
    catch(e){result="이미지 없음";}
    return result;
  }



  //시체 위치 가져오기
  Future<List<MyMap>> getbodylocation()async{
    final db = FirebaseFirestore.instance;
    List<MyMap> result=[];

    await db.collection("body").get().then((querySnapshot) {

      for (int i = 0; i < querySnapshot.size; i++) {

        result.add(
            MyMap(
              querySnapshot.docs[i]['Room'],
              querySnapshot.docs[i]['item1'],
              querySnapshot.docs[i]['item2'],
              querySnapshot.docs[i]['item3'],
              querySnapshot.docs[i]['item4'],
              querySnapshot.docs[i]['item5'],
              querySnapshot.docs[i]['txt'],
            )
        );
      }
    },
      onError: (e) => print("Error completing: $e"),
    );

    return result;
  }

  //시체의 위치가 현재 위치인지 비교
  List checkRoom_Body(List<MyMap> bodyLocation,room,items){
    bool result=false;
    int bodynum=1;

    //문자열 비교 위해 전부 공백 없애기 (현재 위치)
    String myroom=room.trim();
    String myitem1=items[0].trim();
    String myitem2=items[1].trim();
    String myitem3=items[2].trim();
    String myitem4=items[3].trim();
    String myitem5=items[4].trim();


    for(int i = 0; i < bodyLocation.length; i++) {

      //문자열 비교 위해 전부 공백 없애기 (시체 위치)
      String bodyroom = bodyLocation[i].getRoom().trim();
      String bodyitem1 = bodyLocation[i].getItem1().trim();
      String bodyitem2 = bodyLocation[i].getItem2().trim();
      String bodyitem3 = bodyLocation[i].getItem3().trim();
      String bodyitem4 = bodyLocation[i].getItem4().trim();
      String bodyitem5 = bodyLocation[i].getItem5().trim();



      if(bodyroom==myroom&&bodyitem1==myitem1){
        result=true;
        bodynum=int.parse(bodyLocation[i].getTxt());

        if(bodyitem2!=""){
          if(bodyitem2!=myitem2){
            result=false;
          }
          if(bodyitem3!=""){
            if(bodyitem3!=myitem3){
              result=false;
            }
            if(bodyitem4!=""){

              if(bodyitem4!=myitem4){
                result=false;
              }
              if(bodyitem5!=""){
                if(bodyitem5!=myitem5){
                  result=false;
                }
              }
            }
          }
        }
      }

    }

    return [result,bodynum];
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



  Future<int> changebody(Room,item1,item2,item3,item4,item5,txt) async {
    int result=0;
    String body="body"+txt;
    try {
      final db = FirebaseFirestore.instance;
      await db.collection("body").doc(body).update({
        "Room":Room,
        "item1":item1,
        "item2":item2,
        "item3":item3,
        "item4":item4,
        "item5":item5,
        "txt":txt
      });
      result=1;
    }
    catch (e) {
      result=2;
    }
    return result;

  }



}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/DTO/post.dart';
import 'package:myapp/method/userMethod.dart';


class Boardmethod{

  Usermethod usermethod =new Usermethod();


  //모든 글 리턴
  Future<List<Post>> getBoard() async {

    final db = FirebaseFirestore.instance;
    List<Post> BoardList=[];

    await db.collection("board").get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        Post data= new Post(
            docSnapshot["title"],
            docSnapshot["contents"],
            docSnapshot["postUid"],
            docSnapshot["giftName"],
            docSnapshot["recipientUid"],
            docSnapshot["senderUid"],
            docSnapshot["recipientName"],
            docSnapshot["senderName"]
        );
        BoardList.add(data);
      }
      },
        onError: (e) => print("Error completing: $e"),
      );

    //날짜 (postUid)로 내림차순 정렬
    BoardList.sort((a, b) => b.getPostUid().compareTo(a.getPostUid()));

    return BoardList;
  }


  //나에게 온 글 리턴
  Future<List<Post>> getMyBoard(userUid) async {
    final db = FirebaseFirestore.instance;
    List<Post> BoardList = [];

    await db.collection("board").where(
          "recipientUid", isEqualTo: userUid).get().then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Post data = new Post(
              docSnapshot["title"],
              docSnapshot["contents"],
              docSnapshot["postUid"],
              docSnapshot["giftName"],
              docSnapshot["recipientUid"],
              docSnapshot["senderUid"],
              docSnapshot["recipientName"],
              docSnapshot["senderName"]
          );

          BoardList.add(data);
        }
      },
        onError: (e) => print("Error completing: $e"),
      );

    return BoardList;
  }


  //날짜 변환
  List convertDate (PostUid){
    String year=PostUid.substring(0,2);
    String month=PostUid.substring(2,4);
    String date=PostUid.substring(4,6);
    String hour=PostUid.substring(6,8);
    String min=PostUid.substring(8,10);
    String sec=PostUid.substring(10,12);
    return [year,month,date,hour,min,sec];
  }

  //현재 시간과 차이 구하기
  String getDifferTime(postuid){
    // - 현재 시간 받아오기
    var nowTime=DateTime.now();
    // - uid로 올라온 날짜 구하기
    var postTime="20"+postuid.substring(0,2)+"-"+postuid.substring(2,4)+"-"+postuid.substring(4,6)
        +" "+postuid.substring(6,8)+":"+postuid.substring(8,10);

    //- 차이 구하기 (일/시간/분)
    var days =int.parse(nowTime.difference(DateTime.parse(postTime)).inDays.toString());
    if(days==0){    //일 시간 분으로 나눠서 값이 1 이상인 곳으로 리턴 하기
      var hour=int.parse(nowTime.difference(DateTime.parse(postTime)).inHours.toString());
      if(hour==0){
        var min=int.parse(nowTime.difference(DateTime.parse(postTime)).inMinutes.toString());
        return min.toString()+"분 전";
      }
      return hour.toString()+"시간 전";
    }

    //'일' 단위의 경우 30일이 넘어가면 한달전, 60일이 넘어가면 오래전 으로 리턴
    if(days>60){return "오래전";}
    if(days>30&&days<60){return "한달전";}
    return days.toString()+"일 전";
  }

  Future<int> deletePost(uid) async {
    int result=0;
    final db = FirebaseFirestore.instance;
    try{
      await db.collection("board").doc(uid).delete();
      result=1;
    }
    catch(e){
      result=2;
    }
    return result;
  }


}
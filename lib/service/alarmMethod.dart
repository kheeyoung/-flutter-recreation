import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/DTO/personalAlarm.dart';

class AlarmMethod{
  final _authentication = FirebaseAuth.instance;

  Future<List<PersonalAlarm>> getPersonalAlarm() async {
    final user = _authentication.currentUser;
    final db = FirebaseFirestore.instance;

    List<PersonalAlarm> result =[];
    await db.collection("alarm").doc(user!.uid).collection("alarm").get().then(
          (querySnapshot) {

        for (int i=0; i<querySnapshot.size; i++) {

          String time =querySnapshot.docs[i].data()["date"].toString();
          
          PersonalAlarm pa = PersonalAlarm(
              querySnapshot.docs[i].data()["title"],
              querySnapshot.docs[i].data()["contents"],
              "${time.substring(0,2)} ${time.substring(2,4)}/${time.substring(4,6)} ${time.substring(6,8)}:${time.substring(8,10)} ${time.substring(10,12)}"
          );
          result.add(pa);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return result;
  }

  Future<void> addAlarm(pa, String receiver) async {
    try{
      final db = await FirebaseFirestore.instance;

      final MyAlarm = <String, dynamic>{
        "title": pa.title,
        "contents": pa.contents,
        "date": pa.date
      };

      db.collection("alarm").doc(receiver).collection("alarm").doc(pa.date).set(MyAlarm)
          .onError((e, _) => print("Error writing document: $e"));
    }
    catch(e){
    }
  }

  Future<void> deleteAlarm(date)async {
    final user = _authentication.currentUser;
    try{
      final db = await FirebaseFirestore.instance;

      await db.collection("alarm").doc(user!.uid).collection("alarm").doc(date).delete();
    }
    catch(e){
    }
  }
}
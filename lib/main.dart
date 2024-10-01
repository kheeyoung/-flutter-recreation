import 'package:myapp/method/notification_controller.dart';
import 'package:myapp/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screens/login.dart';
import 'package:myapp/screens/notOk.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'method/keyMethod.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //파이어베이스 호출 (비동기 방식 메소드라서 플러터 코어 초기화 필요)
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder.put(()=>NotificationController(),permanent: true),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),//인증자가 바뀔때마다(로그인/아웃)상태 전달
        builder: (context, snapshot){
          WidgetsBinding.instance.addPostFrameCallback((_){});
          if(snapshot.hasData){   //스냅샷이 데이터가 있다면 (=로그인 되어 있다면)

            Keymethod keymethod= Keymethod();

            return FutureBuilder(//메뉴 리턴
              future: Future.wait([keymethod.checkIsOk()]),
              builder: (BuildContext context, AsyncSnapshot snapshotF) {
                if(snapshotF.hasData){
                  bool state= snapshotF.data![0][0];
                  if(!state){
                    return Notok(ExitKey:snapshotF.data![0][1]);
                  }
                  else{
                    print("메뉴로");
                    return Menu();
                  }
                }
                else{
                  return Scaffold(body: Text("로딩중"));
                }
              },

            );
          }
          return Login();   //아니면 로그인창 리턴
        },
      ),
    );
  }
}
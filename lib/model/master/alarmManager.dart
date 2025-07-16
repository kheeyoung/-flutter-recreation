import 'package:flutter/material.dart';

import '../../service/notification_controller.dart';
import '../../service/userMethod.dart';
import '../widget/header.dart';
import '../widget/inputTextFormField.dart';
import '../widget/myNotification.dart';



class Alarmmanager extends StatefulWidget {
  const Alarmmanager({super.key});

  @override
  State<Alarmmanager> createState() => _AlarmmanagerState();
}

class _AlarmmanagerState extends State<Alarmmanager> {
  Header header = Header();
  InputTextFormField inputTextFormField = InputTextFormField();
  MyNotification myNotification = MyNotification();
  Usermethod um = Usermethod();
  NotificationController nc =NotificationController();
  String title = "";
  String contents = "";
  Set<String> selectedUsers=Set();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "알림 관리"),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                //제목
                SizedBox(
                  width: 300,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("제목 : "),
                      SizedBox(
                        width: 262,
                        child: TextFormField(
                          maxLength: 50,
                          key: ValueKey(1),
                          onSaved: (value) {
                            title = value!;
                          },
                          onChanged: (value) {
                            title = value;
                          },
                          decoration:
                          inputTextFormField.basicFormDeco("제목을 입력해주세요."),
                        ),
                      ),
                    ],
                  ),
                ),
                //내용
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("내용 : "),
                      SizedBox(
                        width: 262,
                        height: 200,
                        child: TextFormField(
                          maxLines: 10,
                          maxLength: 100,
                          key: ValueKey(2),
                          onSaved: (value) {
                            contents = value!;
                          },
                          onChanged: (value) {
                            contents = value;
                          },
                          decoration:
                          inputTextFormField.basicFormDeco("내용을 입력해주세요."),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("받을 사람"),
                FutureBuilder(
                    future: um.getUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        List<Widget> w =[];
                        for(String s in snapshot.data.keys.toList()){
                          w.add(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s),
                              Checkbox(
                                value: selectedUsers.contains(s) ? true: false,
                                onChanged: (value) {
                                  if(selectedUsers.contains(s)){
                                    selectedUsers.remove(s);
                                  }
                                  else{selectedUsers.add(s);}
                                  setState(() {
                                  });
                                  print(selectedUsers);
                                },
                              ),

                            ],
                          ));
                        }

                        return Column(children: w,);
                      }
                      return Text("Loading");
                    }),
                OutlinedButton(
                    onPressed: () async {
                      for(String name in selectedUsers){
                        await nc.sendNotification(title, contents, await um.getUserUidByName(name));
                      }

                    },
                    child: Text("전송")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


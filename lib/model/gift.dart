import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/post.dart';
import 'package:myapp/model/widget/dropDownWidget.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';

import '../service/giftMethod.dart';
import '../service/itemMethod.dart';
import '../service/notification_controller.dart';
import '../service/userMethod.dart';


class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> {

  Post post = Post("", "", "", "", "", "", "", "");

  bool loading =true;

  Usermethod um = Usermethod();
  Itemmethod im = Itemmethod();
  Giftmethod gm = Giftmethod();
  InputTextFormField itff = InputTextFormField();
  Header header = Header();
  MyNotification mn = MyNotification();
  NotificationController nc =NotificationController();
  Dropdownwidget dw = Dropdownwidget();

  final _authentication = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    double fullWidth =MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: header.screenHeader(context, "Gift"),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait(
                [um.getUser(), im.getMyItem(user!.uid)]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {

                return Center(
                  child: SizedBox(
                    width: fullWidth*0.8,
                    child: Column(

                      children: [
                        //제목
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("제목 : "),
                              SizedBox(
                                width: fullWidth*0.6,
                                child: TextFormField(
                                  maxLength: 100,
                                  key: ValueKey(1),
                                  onSaved: (value) {post.setTitle(value!);},
                                  onChanged: (value) {post.setTitle(value!);},
                                  decoration: itff.noMarginFormDeco("제목을 입력해주세요."),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //수신인
                        SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("수신인 : "),
                              SizedBox(
                                width: fullWidth*0.6,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: post.getRecipientName().isNotEmpty
                                      ? post.getRecipientName()
                                      : null,
                                  items: dw.makeItems(snapshot.data[0].keys.toList()),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      post.setRecipientName(newValue!);
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  iconSize: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        //선물
                        SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("보낼 선물 : "),
                              SizedBox(
                                width: fullWidth*0.6,
                                child: DropdownButton<String>(
                                  padding: EdgeInsets.zero,
                                  isExpanded: true,
                                  value: post.getGiftName().isNotEmpty ? post.getGiftName() : null,
                                  items: dw.makeItems(snapshot.data[1].keys.toList()),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      post.setGiftName(newValue!);
                                    });
                                  },
                                  dropdownColor: Colors.white,
                                  iconSize: 30,
                                  icon: Icon(Icons.arrow_drop_down)

                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        //내용
                        SizedBox(
                          height: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("내용 : "),
                              SizedBox(
                                width: fullWidth*0.6,
                                height: 200,
                                child: TextFormField(
                                  maxLines: 10,
                                  maxLength: 200,
                                  key: ValueKey(2),
                                  onSaved: (value) {
                                    post.setContents(value!);
                                  },
                                  onChanged: (value) {
                                    post.setContents(value!);
                                  },
                                  decoration: itff.basicFormDeco("내용을 입력해주세요."),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20,),

                        //확인 버튼
                        OutlinedButton(
                            onPressed: () async {
                              if(!loading){
                                return;
                              }

                              if(post.getContents().isEmpty ||
                                  post.getTitle().isEmpty||
                                  post.getGiftName().isEmpty||
                                  post.getRecipientName().isEmpty
                              ){
                                mn.SnackbarBasic(context, "제목, 수신인, 선물, 내용은 필수 항목 입니다.");
                                return;
                              }

                              setState(() {loading=false;});

                              post.setRecipientUid(snapshot.data[0][post.getRecipientName()]);
                              post.setSenderUid(user!.uid);

                              //선물
                              await gm.sendGift(post);

                              //아이템 사용 전환 (가장 오래 된 것 부터 사용)
                              await gm.useItem(post.getGiftName(), user.uid);

                              //호감도
                              if (post.getRecipientUid() == snapshot.data![1][post.getGiftName()]) {
                                gm.addLikePoint(user.uid, post.getRecipientUid(), post.getGiftName());
                              }

                              //알림
                              nc.sendNotification("${post.getGiftName()}이(가) 도착했습니다!", post.getTitle(), post.getRecipientUid());

                              mn.SnackbarBasic(context, "선물 발송 완료!!");

                              setState(() {
                                post.setGiftName("");
                                loading=true;
                              });

                            },
                            child: Text("선물 보내기"))
                      ],
                    ),
                  ),
                );
              }
              return Text("로딩중");
            },
          )
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/DTO/room/roomItemDTO.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/service/roomService.dart';

import '../../widget/myNotification.dart';

class Edittop extends StatefulWidget {
  const Edittop({super.key, required this.uid, required this.rid});
  final String uid;
  final List<RoomItemDto> rid;

  @override
  State<Edittop> createState() => _EdittopState();
}

class _EdittopState extends State<Edittop> {
  MyNotification mn = MyNotification();
  Header header = Header();
  RoomItemDto myrid = RoomItemDto("", "", "", false, []);
  InputTextFormField itff = InputTextFormField();
  RoomService rs =RoomService();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {


          List<Widget> point=[];

          if(widget.rid.isNotEmpty) {
            for (RoomItemDto data in widget.rid) {


              if (data.erasable) {
                point.add(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Text(data.name)),
                    IconButton(
                      padding: EdgeInsets.zero, // 패딩 설정
                      constraints: BoxConstraints(),
                      onPressed: () async {
                        setState(() {
                          showSpinner = true; //로딩 보이게 함
                        });
                        await rs.deleteTopPoint(widget.uid, data.id, context);
                        widget.rid.remove(data);
                        setState(() {
                          showSpinner = false; //로딩 안 보이게 함
                        });
                      },
                      icon: Icon(Icons.delete_forever),
                    ),
                  ],
                ),);
              }
            }
          }

            return Scaffold(
                appBar: header.NotHeader(context, "방 꾸미기", "기본 가구는 삭제가 불가능 합니다."),
                body: ModalProgressHUD(
                  //로딩용
                  inAsyncCall: showSpinner,

                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Padding(

                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(height: 20,),


                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide.none,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        showSpinner = true; //로딩 보이게 함
                                      });

                                      RoomItemDto result= await rs.makeUnderPointAtTop(widget.uid, context);
                                      if(result.name!=""){
                                        widget.rid.add(result);
                                      }

                                      setState(() {
                                        showSpinner = false; //로딩 안 보이게 함
                                      });


                                    },
                                    child: const Text("+ 하위 조사 포인트 추가")),
                              ),
                              SizedBox(height: 20,),
                              Column(
                                children: point,
                              ),
                              SizedBox(height: 20,),





                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          }




}

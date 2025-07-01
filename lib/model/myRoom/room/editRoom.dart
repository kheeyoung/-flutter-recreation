import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/DTO/room/roomItemDTO.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/service/roomService.dart';

import '../../widget/myNotification.dart';

class Editroom extends StatefulWidget {
  const Editroom({super.key, required this.rid, required this.uid});

  final RoomItemDto rid;
  final String uid;

  @override
  State<Editroom> createState() => _EditroomState();
}

class _EditroomState extends State<Editroom> {
  MyNotification mn = MyNotification();
  Header header = Header();
  RoomItemDto myrid = RoomItemDto("", "", "", false, []);
  InputTextFormField itff = InputTextFormField();
  RoomService rs =RoomService();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
      future: rs.getUnderPointDTO(widget.uid, widget.rid.underPoint),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          double fullWidth =MediaQuery.of(context).size.width;

          myrid=widget.rid;


          List<Widget> point=[];

          if(snapshot.hasData){

            for(RoomItemDto data in snapshot.data){
              point.add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text(data.name)),
                  IconButton(
                    padding: EdgeInsets.zero, // 패딩 설정
                    constraints: BoxConstraints(),
                    onPressed: () async{
                      setState(() {
                        showSpinner = true; //로딩 보이게 함
                      });
                      await rs.deletePoint(widget.uid,myrid,data.id, context);
                      setState(() {
                        showSpinner = false; //로딩 안 보이게 함
                      });
                    },
                    icon: Icon(Icons.delete_forever),
                  ),
                ],
              ),);
            }

            return Scaffold(
                appBar: header.screenHeader(context, "방 꾸미기"),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("구역명 : "),
                                  SizedBox(
                                    width: fullWidth*0.6,
                                    child: TextFormField(

                                      maxLength: 100,
                                      initialValue: myrid.name,
                                      onSaved: (value) {myrid.name=value!;},
                                      onChanged: (value) {myrid.name=value!;},
                                      decoration: itff.noMarginFormDeco("구역명을 입력해주세요."),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("설명 : "),
                                  SizedBox(
                                    width: fullWidth*0.6,
                                    child: TextFormField(
                                      maxLength: 100,
                                      initialValue: myrid.text,
                                      onSaved: (value) {myrid.text=value!;},
                                      onChanged: (value) {myrid.text=value!;},
                                      decoration: itff.noMarginFormDeco("설명을 입력해주세요."),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20,),
                              OutlinedButton(onPressed: () async{
                                if(myrid.name.isEmpty || myrid.text.isEmpty){
                                  mn.SnackbarBasic(context, "조사 구역 명과 설명은 필수 입니다.");
                                  return;
                                }

                                //값이 다 있다면
                                setState(() {
                                  showSpinner = true; //로딩 보이게 함
                                });

                                await rs.savePoint(widget.uid,myrid, context);


                                setState(() {
                                  showSpinner = false; //로딩 안 보이게 함
                                });
                              },
                                  child: const Text("저장")),
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

                                      await rs.makeUnderPoint(widget.uid,myrid, context);


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
          return Scaffold(
              appBar: header.screenHeader(context, "방 꾸미기"),
              body: Text("Loading..."));
        }

    );
  }
}

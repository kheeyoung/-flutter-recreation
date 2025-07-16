import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'package:myapp/DTO/inquiryDTO.dart';
import 'package:myapp/DTO/pet/petDTO.dart';
import 'package:myapp/model/miniGame/pet/deadPet.dart';
import 'package:myapp/model/miniGame/pet/managePet.dart';
import 'package:myapp/model/widget/header.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/coinService.dart';
import 'package:myapp/service/petService.dart';

class Pet extends StatefulWidget {
  const Pet({super.key});

  @override
  State<Pet> createState() => _PetState();
}

class _PetState extends State<Pet> {
  PetService ps = PetService();
  Header header = Header();
  InputTextFormField itff = InputTextFormField();
  CoinService cs = CoinService();
  MyNotification mn = MyNotification();
  bool load = false;
  String name = "";

  void _refreshParent() {
    setState(() {});          // ➡️ FutureBuilder가 다시 동작하면서 최신 데이터 로드
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    return ModalProgressHUD(
        inAsyncCall: load,
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: header.NotHeader(
                  context, "Pet", "펫을 잘 관리해주세요.\n관리가 좋지 않을 경우 사망에 이를 수 있습니다."),
              body: FutureBuilder(
                  future: ps.getLivePet(user!.uid, context),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //통금 시간에는 잠
                    if (DateTime.now().hour >= 2 && DateTime.now().hour < 8) {
                      return Center(child: Text("펫은 자고 있다..."));
                    }else{
                      if (snapshot.hasData) {
                        PetDTO pd = snapshot.data;

                        //펫이 없는 경우
                        if (pd.name.isEmpty || pd.name == "") {

                          return Center(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context){
                                          return Deadpet();
                                        }));
                                  }, icon: Icon(Icons.pets)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text("보유하고 있는 펫이 없습니다."),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: fullWidth * 0.6,
                                  child: TextFormField(
                                    maxLength: 100,
                                    key: ValueKey(1),
                                    onSaved: (value) {name = value!;},
                                    onChanged: (value) {name = value!;},
                                    decoration:
                                    itff.noMarginFormDeco("펫의 이름을 입력해주세요."),
                                  ),
                                ),
                                OutlinedButton(
                                    onPressed: () async {
                                      setState(() {load = true;});

                                      if(name==""){
                                        mn.SnackbarBasic(context, "이름은 필수 항목 입니다!");
                                        setState(() {load = false;});
                                        return;
                                      }
                                      int coin = await cs.getCoin(user!.uid);
                                      if (coin < 10) {
                                        mn.SnackbarBasic(context, "코인이 부족합니다!");
                                        setState(() {load = false;});
                                        return;
                                      }
                                      await cs.changeCoin(coin - 10, user!.uid);
                                      await cs.makeInquiry(user!.uid, Inquirydto(-10, "펫 생성", "System", ""));

                                      await ps.makePet(name, user!.uid);

                                      setState(() {load = false;});
                                    },
                                    child: const Text("펫 생성하기 (10 coin)")),

                              ],
                            ),
                          );
                        }

                        else {
                          return Managepet(pd: pd, onRefresh: _refreshParent,);
                        }
                      }
                      return Text("loading...");
                    }

                  }),
            )));
  }
}

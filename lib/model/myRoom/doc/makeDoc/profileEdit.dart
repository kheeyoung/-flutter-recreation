import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/DTO/wikiDTO/profileDTO.dart';
import 'package:myapp/DTO/wikiDTO/wikiDTO.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/service/wikiService.dart';

import '../../../widget/inputTextFormField.dart';

class ProfileEdit extends StatefulWidget {
  final String public;
  const ProfileEdit({super.key, required this.public});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  InputTextFormField itff = InputTextFormField();
  WikiService ws = WikiService();
  final _authentication = FirebaseAuth.instance;
  MyNotification mn = MyNotification();

  final _formKey = GlobalKey<FormState>();

  ProfileDTO? pd; // 비동기 결과 저장
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = _authentication.currentUser;
    if (user != null) {
      ProfileDTO result = await ws.getProfile(user.uid, widget.public);
      setState(() {
        pd = result;
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final user = _authentication.currentUser;
    double fullWidth = MediaQuery
        .of(context)
        .size
        .width;

    if (isLoading) {
      return Center(child: Text("Loading..."));
    }

    if (pd == null) {
      return Center(child: Text("Profile not found."));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: Container(
          width: fullWidth*0.8,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //재능
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("재능"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("재능을 입력해주세요."),
                        initialValue: pd!.talent,
                        maxLength: 20,
                        key: ValueKey(1),
                        onSaved: (value) {pd!.talent=value!;},
                      ),
                    ),
                  ],
                ),

                //이름
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("이름"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("이름을 입력해주세요."),
                        initialValue: pd!.name,
                        maxLength: 20,
                        key: ValueKey(2),
                        onSaved: (value) {pd!.name=value!;},
                      ),
                    ),
                  ],
                ),

                //이미지
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("이미지"),
                    Column(
                      children: [

                        OutlinedButton(
                            style: OutlinedButton.styleFrom(minimumSize: Size.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)) ),
                            onPressed: ()async{
                              final ImagePicker picker = ImagePicker();
                              final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                mn.showLoadingDialog(context);
                                try {
                                  final storageRef = FirebaseStorage.instance.ref();
                                  var imagesRef = storageRef.child('wikiImage/publicbody/${user!.uid}.png');
                                  if(widget.public=="private"){
                                    imagesRef = storageRef.child('wikiImage/privatebody/${user!.uid}.png');
                                  }
                                  await imagesRef.putFile(File(pickedFile.path));

                                  pd!.bodyImage=await imagesRef.getDownloadURL();

                                  mn.SnackbarBasic(context, "등록 성공");
                                  mn.hideLoadingDialog(context);
                                  return;
                                } catch (e) {
                                  mn.SnackbarBasic(context, "등록 실패");
                                }
                              }
                              mn.SnackbarBasic(context, "등록 실패");
                              mn.hideLoadingDialog(context);
                            },
                            child: Text("이미지 등록")
                        ),
                      ],
                    ),
                  ],
                ),

                //원어
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("원어"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("원어 이름을 입력해주세요."),
                        initialValue: pd!.originName,
                        maxLength: 20,
                        key: ValueKey(3),
                        onSaved: (value) {pd!.originName=value!;},
                      ),
                    ),
                  ],
                ),

                //한마디
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("한마디"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("한마디를 입력해주세요."),
                        initialValue: pd!.oneWord,
                        maxLength: 40,
                        key: ValueKey(4),
                        onSaved: (value) {pd!.oneWord=value!;},
                      ),
                    ),
                  ],
                ),

                //인지도
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("인지도"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("인지도를 입력해주세요."),
                        initialValue: pd!.awareness,
                        maxLength: 20,
                        key: ValueKey(5),
                        onSaved: (value) {pd!.awareness=value!;},
                      ),
                    ),
                  ],
                ),

                //신장
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("신장"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("신장을 입력해주세요."),
                        initialValue: pd!.height,
                        maxLength: 20,
                        key: ValueKey(6),
                        onSaved: (value) {pd!.height=value!;},
                      ),
                    ),
                  ],
                ),

                //체중
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("체중"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("체중을 입력해주세요."),
                        initialValue: pd!.weight,
                        maxLength: 20,
                        key: ValueKey(7),
                        onSaved: (value) {pd!.weight=value!;},
                      ),
                    ),
                  ],
                ),

                //나이
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("나이"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("나이를 입력해주세요."),
                        initialValue: pd!.age,
                        maxLength: 20,
                        key: ValueKey(8),
                        onSaved: (value) {pd!.age=value!;},
                      ),
                    ),
                  ],
                ),

                //생일
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("생일"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("생일을 입력해주세요."),
                        initialValue: pd!.birth,
                        maxLength: 20,
                        key: ValueKey(9),
                        onSaved: (value) {pd!.birth=value!;},
                      ),
                    ),
                  ],
                ),

                //관계
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("관계"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("관계를 입력해주세요."),
                        initialValue: pd!.relationship,
                        maxLength: 20,
                        key: ValueKey(10),
                        onSaved: (value) {pd!.relationship=value!;},
                      ),
                    ),
                  ],
                ),

                //소지품
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("소지품 1"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("소지품을 입력해주세요."),
                        initialValue: pd!.belongings1,
                        maxLength: 20,
                        key: ValueKey(11),
                        onSaved: (value) {pd!.belongings1=value!;},
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("소지품 2"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("소지품을 입력해주세요."),
                        initialValue: pd!.belongings2,
                        maxLength: 20,
                        key: ValueKey(12),
                        onSaved: (value) {pd!.belongings2=value!;},
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("소지품 3"),
                    Container(
                      width: fullWidth*0.5,
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: itff.noMarginFormDeco("소지품을 입력해주세요."),
                        initialValue: pd!.belongings3,
                        maxLength: 20,
                        key: ValueKey(13),
                        onSaved: (value) {pd!.belongings3=value!;},
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 20,),
                OutlinedButton(
                    onPressed: () async {
                      _formKey.currentState!.save();
                      await ws.saveProfile(pd!,user!.uid, widget.public, context);
                    },
                    child: Text("저장"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

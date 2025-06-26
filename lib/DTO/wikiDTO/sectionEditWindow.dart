import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/DTO/wikiDTO/profileDTO.dart';
import 'package:myapp/DTO/wikiDTO/sectionDTO.dart';

import '../../model/widget/inputTextFormField.dart';
import '../../model/widget/myNotification.dart';
import '../../service/wikiService.dart';

class Sectioneditwindow extends StatefulWidget {
  final String uid;
  final String public;
  final SectionDto sd;


  const Sectioneditwindow({super.key, required this.sd, required this.uid, required this.public});

  @override
  State<Sectioneditwindow> createState() => _SectioneditwindowState();
}

class _SectioneditwindowState extends State<Sectioneditwindow> {
  InputTextFormField itff = InputTextFormField();
  WikiService ws = WikiService();
  MyNotification mn = MyNotification();

  // 여기에 sd를 State 변수로 선언하고 초기화합니다.
  late SectionDto _currentSd; // _를 붙여 private 변수임을 나타냅니다.

  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 widget.sd의 내용을 _currentSd에 복사합니다.
    // 만약 SectionDto가 mutable 하다면 깊은 복사(deep copy)를 고려해야 합니다.
    // 현재 코드에서는 SectionDto의 필드를 직접 변경하고 있으므로, 참조만 복사해도 괜찮습니다.
    _currentSd = widget.sd; // 또는 widget.sd를 직접 할당해도 됩니다.
    // _currentSd = widget.sd;
  }


  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    Widget image = Text("이미지 등록하기");
    if(_currentSd.image.isNotEmpty){
      image=Container(
        width: fullWidth*0.4,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Image.network(
            _currentSd.image,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.grey, size: 50),
                    Text("No Image"),
                  ],
                ),
              );
            },
          ),

      );
    }


    return ExpansionTile(title: Text(_currentSd.title), children: [ // <-- _currentSd 사용
      Container(
        padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
        child: Column(
          children: [
            //제목
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("제목"),
                Container(
                  width: fullWidth * 0.7,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                      decoration: itff.noMarginFormDeco("제목을 입력해주세요."),
                      initialValue: _currentSd.title, // <-- _currentSd 사용
                      maxLength: 20,
                      // onSaved는 Form 위젯과 함께 사용될 때 호출됩니다.
                      // 일반적으로 onSaved에서 setState를 할 필요는 없습니다.
                      onSaved: (value) {
                        setState(() {
                          _currentSd.title = value!; // <-- _currentSd 사용
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          _currentSd.title = value!; // <-- _currentSd 사용
                        });
                      }),
                ),
              ],
            ),
            //이미지
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("이미지"),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)) ),
                    onPressed: ()async{
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        try {
                          mn.showLoadingDialog(context);
                          final storageRef = FirebaseStorage.instance.ref();
                          var imagesRef = storageRef.child('wikiImage/etc/${widget.uid}/${pickedFile.name}');
                          await imagesRef.putFile(File(pickedFile.path));
                          _currentSd.image=await imagesRef.getDownloadURL();
                          setState(() {
                          });

                        } catch (e) {
                        }
                        mn.hideLoadingDialog(context);
                      }

                    },
                    child: image
                ),
                IconButton(onPressed: (){setState(() {
                  _currentSd.image="";
                });}, icon: Icon(Icons.delete_forever))
              ],
            ),
            //한마디
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("한마디"),
                Container(
                  width: fullWidth * 0.7,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                      decoration: itff.noMarginFormDeco("한마디를 입력해주세요. (공란 가능)"),
                      initialValue: _currentSd.oneWord, // <-- _currentSd 사용
                      maxLength: 20,
                      onSaved: (value) {
                        setState(() { // <-- 한마디도 setState 추가
                          _currentSd.oneWord = value!; // <-- _currentSd 사용
                        });
                      },
                      onChanged: (value) {
                        setState(() { // <-- 한마디도 setState 추가
                          _currentSd.oneWord = value!; // <-- _currentSd 사용
                        });
                      }),
                ),
              ],
            ),
            //내용
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("내용"),
                Container(
                  width: fullWidth * 0.7,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: itff.noMarginFormDeco("내용을 입력해주세요."),
                    initialValue: _currentSd.content, // <-- _currentSd 사용
                    onSaved: (value) {
                      setState(() { // <-- 내용도 setState 추가
                        _currentSd.content = value!; // <-- _currentSd 사용
                      });
                    },
                    onChanged: (value) {
                      setState(() { // <-- 내용도 setState 추가
                        _currentSd.content = value!; // <-- _currentSd 사용
                      });
                    },
                    minLines: 1,
                    // 최소 1줄
                    maxLines: null,
                    // null로 하면 줄 수 무제한
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //저장버튼
                IconButton(onPressed: ()async {
                  print(_currentSd.title); // <-- 이제 _currentSd를 출력!
                  await ws.saveSection(_currentSd,widget.uid, widget.public, context); // <-- _currentSd 전달
                  setState(() {
                    // 저장 후 UI 갱신이 필요하다면 여기에 추가
                  });
                }, icon: Icon(Icons.check)),

              ],
            )
          ],
        ),
      )
    ]);
  }
}

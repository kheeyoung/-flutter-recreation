import 'package:flutter/material.dart';
import 'package:myapp/DTO/wikiDTO/wikiDTO.dart';
import 'package:myapp/service/wikiService.dart';

import '../../../widget/inputTextFormField.dart';
class Basicinfo extends StatefulWidget {
  final user;
  final WikiDto wd;
  const Basicinfo({super.key, required this.user,required this.wd});

  @override
  State<Basicinfo> createState() => _BasicinfoState();
}

class _BasicinfoState extends State<Basicinfo> {
  InputTextFormField itff = InputTextFormField();
  WikiService ws = WikiService();

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: fullWidth*0.8,
        child: Column(
          children: [
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
                      initialValue: widget.wd.name,
                      maxLength: 20,
                      key: ValueKey(1),
                      onSaved: (value) {widget.wd.name=value!;},
                      onChanged: (value) {widget.wd.name=value!;}
                  ),
                ),
              ],
            ),

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
                      initialValue: widget.wd.talent,
                      maxLength: 20,
                      key: ValueKey(1),
                      onSaved: (value) {widget.wd.talent=value!;},
                      onChanged: (value) {widget.wd.talent=value!;}
                  ),
                ),
              ],
            ),

            //색상
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("색상코드"),
                Container(
                  width: fullWidth*0.5,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                      decoration: itff.noMarginFormDeco("색상코드 6자리 (# 제외)"),
                      initialValue: widget.wd.color,
                      maxLength: 6,
                      key: ValueKey(1),
                      onSaved: (value) {widget.wd.color=value!;},
                      onChanged: (value) {widget.wd.color=value!;}
                  ),
                ),
              ],
            ),
            //비밀 프로필 공개 여부
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("비밀 프로필 공개 여부"),
                Switch(

                    value: widget.wd.private,
                    onChanged: (value){setState(() {
                  widget.wd.private = value;
                });})
              ],
            ),
            SizedBox(height: 20,),
            OutlinedButton(
                onPressed: () async {
                  await ws.saveBaisc(widget.wd, widget.user, context);
                },
                child: Text("저장"))
          ],
        ),
      ),
    );
  }
}

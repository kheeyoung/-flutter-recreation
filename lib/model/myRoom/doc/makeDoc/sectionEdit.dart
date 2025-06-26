import 'package:flutter/material.dart';
import 'package:myapp/DTO/wikiDTO/sectionDTO.dart';
import 'package:myapp/DTO/wikiDTO/sectionEditWindow.dart';
import 'package:myapp/model/widget/inputTextFormField.dart';
import 'package:myapp/model/widget/myNotification.dart';
import 'package:myapp/model/widget/wikiAccordion.dart';
import 'package:myapp/service/wikiService.dart';

class Sectionedit extends StatefulWidget {
  final String uid;
  final String public;

  const Sectionedit({super.key, required this.uid, required this.public});

  @override
  State<Sectionedit> createState() => _SectioneditState();
}

class _SectioneditState extends State<Sectionedit> {
  WikiService ws = WikiService();
  InputTextFormField itff = InputTextFormField();
  MyNotification mn =MyNotification();

  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
        future: ws.getPersonalDoc(widget.uid, widget.public),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (snapshot.hasData) {
            List<Widget> list = [];
            for (SectionDto data in snapshot.data) {

              list.add(Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                      Expanded(child: GestureDetector(
                        //꾹 눌러서 순서 이동

                        //밀어서 삭제
                        onPanEnd: (details) {
                          mn.DialogDelete(context,  data, widget.uid,widget.public);
                          setState(() {
                          });
                        },
                          child: Sectioneditwindow(sd: data, uid: widget.uid, public: widget.public))
                      ),
                ],
              ));
            }


            //새 문서 버튼
            list.add(OutlinedButton(
                onPressed: () async {
                    await ws.addSection(SectionDto("새 문서", "", "", "",""), widget.uid, widget.public);
                    setState(() {
                    });
                },
                child: Text("새 문서 추가"))
            );

            return Column(
              children: list,
            );
          }
          return Text("Loading...");
        });
  }
}

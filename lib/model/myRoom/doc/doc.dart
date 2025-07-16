import 'package:flutter/material.dart';
import 'package:myapp/model/myRoom/doc/makeDoc/makeDoc.dart';
import 'package:myapp/service/wikiService.dart';
import '../../widget/header.dart';

class Doc extends StatefulWidget {
  const Doc({super.key});

  @override
  State<Doc> createState() => _DocState();
}

class _DocState extends State<Doc> {
  Header header = Header();
  WikiService ws = WikiService();

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double iconSize = fullWidth * 0.2;
    return Scaffold(
        appBar: header.screenHeader(context, "Doc"),
        body: FutureBuilder(
            future: ws.getWiki(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                List<Widget> iconList =
                    ws.makeIconList(snapshot.data, iconSize, context);

                Widget table = ws.makeTable(iconList, iconSize);

                return Center(
                  child: Container(
                    width: fullWidth*0.8,
                    child: Column(
                        children: [
                          table,
                          Align(
                            alignment: Alignment.centerRight,
                              child: IconButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Makedoc()),
                                );
                              }, icon: Icon(Icons.edit)))
                        ],

                    ),
                  ),
                );
              }
              return Text("Loading...");
            }));
  }
}

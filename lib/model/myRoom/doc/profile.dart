import 'package:flutter/material.dart';
import 'package:myapp/DTO/wikiDTO/profileDTO.dart';
import 'package:myapp/DTO/wikiDTO/wikiDTO.dart';
import 'package:myapp/model/widget/wikiAccordion.dart';
import 'package:myapp/model/widget/wikiTextBox.dart';
import '../../../service/wikiService.dart';


class Profile extends StatefulWidget {
  final WikiDto wd;
  final String public;

  const Profile({super.key, required this.wd, required this.public});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  WikiService ws = WikiService();


  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    WikiDto wd = widget.wd;
    return FutureBuilder(
        future: Future.wait([
          ws.getProfile(wd.uid, widget.public),
          ws.getImage(wd.uid, widget.public),
          ws.getForm(wd.uid, widget.public)
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          ProfileDTO pd = ProfileDTO(
              "", "", "", "", "", "", "", "", "", "", "", "", "", "");
          String url ="";
          String form ="";
          if (snapshot.hasData) {
            pd = snapshot.data[0];
            url =snapshot.data[1];
            form =snapshot.data[2];
          }

          return SingleChildScrollView(
            child: Column(
              children: [

                Container(

                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Container(
                        width: fullWidth*0.6,
                        child: Table(

                          border: TableBorder.all(color: Colors.black12), // 테두리 선택
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  color: ws.colorFromHex(wd.color),
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("<초세계급 ${pd.talent}>"),
                                      Text(pd.name),
                                      Text(pd.originName),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: (url != null && url.isNotEmpty)
                                      ? Image.network(
                                    url,
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
                                  )
                                      : const Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.broken_image, color: Colors.grey, size: 50),
                                        Text("No Image"),
                                      ],
                                    ),
                                  ),
                                )

                              ],
                            ),


                          ],
                        ),
                      ),
                      Container(
                        width: fullWidth*0.6,
                        child: Table(
                          columnWidths: const {
                            0: FixedColumnWidth(70), // 왼쪽 제목 셀
                          },
                          border: TableBorder.all(color: Colors.black12), // 테두리 선택
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: [

                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("재능"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(pd.talent),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("인지도"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(pd.awareness),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("신체\n사이즈"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("신장 - ${pd.height}"),
                                      Text("체중 - ${pd.weight}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("나이"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(pd.age),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("생일"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(pd.birth),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("관계"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(pd.relationship),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.fill,
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.black12,
                                    padding: EdgeInsets.all(8),
                                    child: Text("\n소지품\n"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pd.belongings1),
                                      Text(pd.belongings2),
                                      Text(pd.belongings3),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                Wikiaccordion(content:
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: (form != null && form.isNotEmpty)
                          ? Image.network(
                        form,
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
                      )
                          : const Center(
                        child: Column(
                          children: [
                            Icon(Icons.broken_image, color: Colors.grey, size: 50),
                            Text("No Image"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: Wikitextbox(text: pd.oneWord,color: wd.color,)
                    ),
                    const SizedBox(height: 10,),
                    Container(
                        alignment : Alignment.centerLeft,
                        child: Text("Durham Rail & Iron Co 열차의 탑승자"))
                  ],
                ),
                  title: "개요", num: "1")

              ],
            ),
          );
        });
  }
}

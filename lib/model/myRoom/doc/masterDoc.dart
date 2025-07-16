import 'package:flutter/material.dart';
import '../../../DTO/wikiDTO/profileDTO.dart';
import '../../../service/wikiService.dart';
import '../../widget/header.dart';

class Masterdoc extends StatefulWidget {

  const Masterdoc({super.key});

  @override
  State<Masterdoc> createState() => _MasterdocState();
}

class _MasterdocState extends State<Masterdoc> {
  Header header = Header();
  WikiService ws =WikiService();

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    var h = header.NotHeader(context, "Doc", "문서 수정은 본인의 것만 가능 합니다.");
    return Scaffold(
        appBar: h,
        body: FutureBuilder(
            future: Future.wait([
              ws.getProfile("master", "public"),
              ws.getImage("master", "public"),
            ]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {

              ProfileDTO pd = ProfileDTO(
                  "", "", "", "", "", "", "", "", "", "", "", "", "", "");
              String url ="";
              if (snapshot.hasData) {
                pd = snapshot.data[0];
                url =snapshot.data[1];
              }

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                  
                      Container(
                  
                        alignment: Alignment.centerLeft ,
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
                                        color: ws.colorFromHex("BE8E6C"),
                                        padding: EdgeInsets.all(8),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text("<Durham Rail의 ${pd.talent}>"),
                                            Text(pd.name, style: TextStyle(fontWeight: FontWeight.bold),),
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
                                          child: Text("직업"),
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
                  
                  
                  
                    ],
                  ),
                ),
              );
            })
    );
  }
}

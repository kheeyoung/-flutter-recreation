import 'package:flutter/material.dart';
import 'package:myapp/model/widget/myNotification.dart';
import '../service/alarmMethod.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  AlarmMethod am = AlarmMethod();
  MyNotification mn = MyNotification();


  @override
  Widget build(BuildContext context) {
    List<DataRow> data = [];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  data = List.from(data.reversed);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.swap_vert,
                  color: Colors.black54,
                )),
          ],
        ),
        body: FutureBuilder(
            future: am.getPersonalAlarm(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                data = [];
                if (data.isEmpty) {
                  for (int i = 0; i < snapshot.data.length; i++) {
                    data.add(DataRow(
                        onSelectChanged: (newValue) {
                          mn.DialogToAlarm(context, snapshot.data[i]);
                        },
                        cells: [
                          DataCell(Container(
                              width:
                              MediaQuery.of(context).size.width *
                                  0.6,
                              child: Text(snapshot.data[i].title))),
                          DataCell(Container(
                              width:
                              MediaQuery.of(context).size.width *
                                  0.25,
                              child: IconButton(
                                onPressed: () async {
                                  await am.deleteAlarm(snapshot
                                      .data[i].date
                                      .replaceAll(RegExp('\\D'), ""));
                                  mn.SnackbarBasic(
                                      context, "알림이 삭제되었습니다.");
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete_forever),
                              ))),
                        ]));
                  }
                  data = List.from(data.reversed);
                }

                return Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: RefreshIndicator(
                        backgroundColor: Colors.transparent,
                        color: Colors.white,
                        onRefresh: () async {
                          setState(() {});
                        },
                        child: ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              DataTable(
                                showCheckboxColumn: false,
                                horizontalMargin: 12.0,
                                columnSpacing: 10.0,
                                columns: const [
                                  DataColumn(
                                      label: Text('title',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  DataColumn(
                                      label: Text(' ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)))
                                ],
                                rows: data,
                              )
                            ]
                        )
                    ),
                  ),
                );
              }
              return Text("Loading");
            })
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/method/alarmMethod.dart';
import 'package:myapp/widget/header.dart';
import 'package:myapp/widget/myNotification.dart';
class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  AlarmMethod am = AlarmMethod();
  MyNotification mn = MyNotification();
  Header header = Header();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header.screenHeader(context, "Notifications"),
      body: Center(
        child: Column(
          children: [

            FutureBuilder(future: am.getPersonalAlarm(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                List<DataRow> data = [];
                for(int i=0; i<snapshot.data.length; i++){
                  data.add(
                      DataRow(
                          onSelectChanged: (newValue) {
                            mn.DialogToAlarm(context,snapshot.data[i]);

                          },
                          cells: [
                            DataCell(Container(width : MediaQuery.of(context).size.width * 0.6,child: Text(snapshot.data[i].title))),
                            DataCell(Container(width : MediaQuery.of(context).size.width * 0.25, child: Text(snapshot.data[i].date))),
                          ]));

                }
                return DataTable(
                  showCheckboxColumn: false,
                  horizontalMargin: 12.0,
                  columnSpacing: 10.0,
                  columns: const [

                    DataColumn(label: Text('title',style: TextStyle(fontWeight: FontWeight.bold))),

                    DataColumn(label: Text('date',style: TextStyle(fontWeight: FontWeight.bold)))
                  ],
                  rows: data,
                );
              }
              return Text("Loading");
            })
          ],
        ),
      ),
    );
  }


}



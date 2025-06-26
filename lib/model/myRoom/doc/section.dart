import 'package:flutter/material.dart';
import 'package:myapp/DTO/wikiDTO/sectionDTO.dart';
import 'package:myapp/model/widget/wikiAccordion.dart';
import '../../../service/wikiService.dart';
import '../../widget/wikiTextBox.dart';

class Section extends StatefulWidget {
  final String public;
  final String uid;
  final String color;
  const Section({super.key, required this.public, required this.uid, required this.color});

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  WikiService ws =WikiService();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: ws.getPersonalDoc(widget.uid, widget.public),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            List<Widget> w =[];
            int i =2;
            for(SectionDto data in snapshot.data){

              List<Widget> contents=[];

              if(data.image.isNotEmpty){
                contents.add(Image.network(
                  data.image,
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
                ));
                contents.add(const SizedBox(height: 10,));
              }
              if(data.oneWord!=""){
                contents.add(Container(
                    alignment: Alignment.centerLeft,
                    child: Wikitextbox(text: data.oneWord,color: widget.color,)
                ));
                contents.add(const SizedBox(height: 10,));
              }

              contents.add(Container(
                  alignment: Alignment.centerLeft,
                  child: Text(data.content)));
              w.add(
                Wikiaccordion(
                    content: Column(
                      children: contents
                    ), 
                    title: data.title, num: i.toString())
              );
              i++;
            }
            
            return Column(children: w,);
          }
          return SizedBox();
      });
  }
}

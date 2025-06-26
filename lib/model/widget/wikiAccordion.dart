
import 'package:flutter/material.dart';

class Wikiaccordion extends StatefulWidget {
  final Widget content;
  final String title;
  final String num;
  const Wikiaccordion({super.key, required this.content, required this.title, required this.num});

  @override
  State<Wikiaccordion> createState() => _WikiaccordionState();
}

class _WikiaccordionState extends State<Wikiaccordion> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          Text("${widget.num}."),
          SizedBox(width: 10,),
          Text(widget.title),
        ],
      ),
      initiallyExpanded: true,
      children: [Container(
        padding: EdgeInsets.all(10),
          child: widget.content
      )],
    );
  }
}

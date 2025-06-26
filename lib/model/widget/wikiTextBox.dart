import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:myapp/service/wikiService.dart';

class Wikitextbox extends StatefulWidget {
  final String text;
  final String color;
  const Wikitextbox({super.key, required this.text, required this.color});

  @override
  State<Wikitextbox> createState() => _WikitextboxState();
}

class _WikitextboxState extends State<Wikitextbox> {
  WikiService ws= WikiService();
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: DottedBorder(
        padding: EdgeInsets.zero,
        color: Colors.black12,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                color: ws.colorFromHex(widget.color),
                child: const Text(""),
              ),
              Flexible(
                child: IntrinsicWidth(
                  child: Container(
                    color: ws.colorFromHex("eeeeee"),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.text,
                      softWrap: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

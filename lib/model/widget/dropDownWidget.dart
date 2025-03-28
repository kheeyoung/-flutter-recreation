
import 'package:flutter/material.dart';
import 'package:myapp/service/userMethod.dart';

import '../../service/itemMethod.dart';

class Dropdownwidget{
  Usermethod um = Usermethod();
  Itemmethod im = Itemmethod();



  List<DropdownMenuItem<String>> makeItems(List<String> l) {
    return l.map((e) => DropdownMenuItem(
      value: e,
      child: Text(e,
        style: const TextStyle(color: Colors.black),
      ),
    )).toList();
  }



}
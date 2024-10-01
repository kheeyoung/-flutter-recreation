import 'package:flutter/material.dart';

class InputTextFormField {
  //기본 입력창 데코
  InputDecoration circleFormDeco(hintText) {
    return InputDecoration(
        enabledBorder: const OutlineInputBorder(
            //입력창 타원 형태로 만들기
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.all(Radius.circular(35.0))),
        focusedBorder: const OutlineInputBorder(
            //입력창 타원 형태가 클릭시에도 유지되게 만들기
            borderSide: BorderSide(color: Colors.black54),
            borderRadius: BorderRadius.all(Radius.circular(35.0))),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
        contentPadding: const EdgeInsets.all(10)
    );
  }

  InputDecoration basicFormDeco(hintText) {
    return InputDecoration(

        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
        contentPadding: const EdgeInsets.all(10),

    );
  }
}

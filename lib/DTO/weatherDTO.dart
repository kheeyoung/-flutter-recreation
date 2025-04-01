import 'package:flutter/material.dart';

class Weatherdto{
  String _main;
  double _temp;
  String _description;
  int _humidity;
  String _icon;

  Weatherdto(
      this._main, this._temp, this._description, this._humidity, this._icon);

  String get main => _main;

  set main(String value) {
    _main = value;
  }

  double get temp => _temp;

  set temp(double value) {
    _temp = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get humidity => _humidity;

  set humidity(int value) {
    _humidity = value;
  }

  String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }
}
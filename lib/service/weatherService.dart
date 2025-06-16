import 'package:flutter/material.dart';
import 'package:myapp/service/networkService.dart';

import '../DTO/weatherDTO.dart';

class Weatherservice{


  Future<Weatherdto> getWeather()async{
    final data = await Networkservice().getData(
        'https://api.openweathermap.org/data/2.5/weather?lat=38&lon=130&appid=3fc18b18176d837d75208d27473a6593'
    );

    double temp = data['main']['temp'].toDouble()-273.15;

    return Weatherdto(
        data['weather'][0]['main'].toString(),
        double.parse(temp.toStringAsFixed(2)),
        data['weather'][0]['description'].toString(),
        data['main']['humidity'].toInt(),
        data['weather'][0]['icon'].toString()
    );
  }

  Icon getIcons(String state, double size){
    switch(state){
      case "01d":
        return Icon(Icons.sunny, size: size,);
      case "02d":
        return Icon(Icons.wb_cloudy_outlined, size: size);
      case "03d":
        return Icon(Icons.cloud, size: size);
      case "04d":
        return Icon(Icons.cloud, size: size);
      case "09d":
        return Icon(Icons.umbrella, size: size);
      case "10d":
        return Icon(Icons.umbrella, size: size);
      case "11d":
        return Icon(Icons.thunderstorm_outlined, size: size);
      case "13d":
        return Icon(Icons.ac_unit, size: size);
      case "50d":
        return Icon(Icons.snowing, size: size);
    }

    return Icon(Icons.question_mark, size: size);
  }
}
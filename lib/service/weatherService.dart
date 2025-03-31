import 'package:myapp/service/networkService.dart';

import '../DTO/weatherDTO.dart';

class Weatherservice{


  Future<Weatherdto> getWeather()async{
    final data = await Networkservice().getData(
        'https://api.openweathermap.org/data/2.5/weather?lat=38&lon=130&appid=3fc18b18176d837d75208d27473a6593'
    );
    return Weatherdto(
        data['main']['temp'],
        data['weather'][0]['main'],
        data['weather'][0]['id'],
        data['main']['humidity']
    );
  }
}
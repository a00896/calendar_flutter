import 'dart:convert';

import 'package:calendar2/model/calendar_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // static 붙이는 이유 : state가 없어서 만들어주기 위함
  static const String baseUrl =
      "https://calendar-a00896-default-rtdb.asia-southeast1.firebasedatabase.app";
  static const String today = "today";

  static Future<List<CalendarModel>> getData() async {
    List<CalendarModel> calendarInstances = [];
    String id = '12';
    final url = Uri.parse('$baseUrl/$id.json'); // API에 HTTP 요청을 보냄
    final response =
        await http.get(url); // Future 타입 반환 ( 당장 완료될 수 있는 작업이 아닐 때 )
    if (response.statusCode == 200) {
      // 성공했는지 확인
      // final data = jsonDecode(response
      //     .body); // response.body는 String 타입으로 저장됨 -> JSON으로 변환해야함 jsonDecode함수 사용
      // print(data);

      final datas = jsonDecode(response.body);

      for (Map<String, dynamic> data in datas) {
        calendarInstances.add(CalendarModel.fromJson(data));
      }
      print(calendarInstances);

      return calendarInstances;
    }
    throw Error();
  }
}

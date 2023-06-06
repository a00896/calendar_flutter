class CalendarModel {
  final String id, title, description;

  CalendarModel.fromJson(
      Map<String, dynamic> json) // Constructor의 인수만 적어주고 property를 적으면 초기화
      : id = json['id'],
        title = json['title'],
        description = json['description'];
}

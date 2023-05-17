import 'package:calendar2/constants/gaps.dart';
import 'package:calendar2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Event Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: "ko-KR",
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
            ),
            Gaps.v32,
            GestureDetector(
              onTap: ApiService.getData,
              child: Container(
                width: 500,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

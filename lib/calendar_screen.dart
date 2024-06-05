import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'diary.dart';
import 'diary_detail_screen.dart';

Color getContrastingTextColor(Color backgroundColor) {
  double luminance = (0.299 * backgroundColor.red +
          0.587 * backgroundColor.green +
          0.114 * backgroundColor.blue) /
      255;

  return luminance > 0.5 ? Colors.black : Colors.white;
}

class CalendarScreen extends StatefulWidget {
  final Function(Diary) onDelete;
  final Function(Diary) onUpdate;

  const CalendarScreen(
      {super.key, required this.onDelete, required this.onUpdate});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Diary>> _events = {};
  late final ValueNotifier<List<Diary>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadDiaries();
  }

  List<Diary> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  Future<void> _loadDiaries() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/diaries.json');

      if (await file.exists()) {
        String jsonString = await file.readAsString();
        List<dynamic> jsonList = json.decode(jsonString);
        List<Diary> diaries = jsonList.map((e) => Diary.fromJson(e)).toList();

        setState(() {
          _events.clear();
          for (Diary diary in diaries) {
            DateTime day =
                DateTime(diary.date.year, diary.date.month, diary.date.day);
            if (_events[day] == null) {
              _events[day] = [];
            }
            _events[day]!.add(diary);
          }
          _selectedEvents.value = _getEventsForDay(_selectedDay!);
        });
      }
    } catch (e) {
      print('Error loading diaries: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(selectedDay);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = getContrastingTextColor(theme.primaryColor);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.colorScheme.secondary,
            theme.scaffoldBackgroundColor
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('캘린더'),
          backgroundColor: theme.primaryColor,
          titleTextStyle: TextStyle(color: textColor),
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              eventLoader: (day) => _getEventsForDay(day),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: textColor),
                weekendTextStyle: TextStyle(color: textColor),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayTextStyle: TextStyle(color: textColor),
                outsideTextStyle: TextStyle(color: textColor.withOpacity(0.6)),
                markerDecoration: BoxDecoration(
                  color: textColor,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(color: textColor, fontSize: 16.0),
                formatButtonTextStyle: TextStyle(color: textColor),
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColor,
                        ),
                        width: 16.0,
                        height: 16.0,
                        child: Center(
                          child: Text(
                            '${events.length}',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Diary>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return value.isNotEmpty
                      ? ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            Diary diary = value[index];
                            return ListTile(
                              title: Text(diary.title,
                                  style: TextStyle(color: textColor)),
                              subtitle: Text(diary.content,
                                  style: TextStyle(color: textColor)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiaryDetailScreen(
                                      diary: diary,
                                      onDelete: widget.onDelete,
                                      onUpdate: widget.onUpdate,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text('No diaries for this day.'),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

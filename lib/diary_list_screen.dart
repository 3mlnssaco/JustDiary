import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'diary.dart';
import 'edit_diary_screen.dart';
import 'diary_detail_screen.dart';

Color getContrastingTextColor(Color backgroundColor) {
  double luminance = (0.299 * backgroundColor.red +
          0.587 * backgroundColor.green +
          0.114 * backgroundColor.blue) /
      255;

  return luminance > 0.5 ? Colors.black : Colors.white;
}

class DiaryListScreen extends StatefulWidget {
  final Function(List<Diary>) onDiariesLoaded;

  const DiaryListScreen({required this.onDiariesLoaded, Key? key})
      : super(key: key);

  @override
  DiaryListScreenState createState() => DiaryListScreenState();
}

class DiaryListScreenState extends State<DiaryListScreen> {
  List<Diary> _diaries = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _isAscending = true; // 정렬 순서를 결정하는 변수

  @override
  void initState() {
    super.initState();
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/diaries.json');

    if (await file.exists()) {
      String jsonString = await file.readAsString();
      List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _diaries = jsonList.map((e) => Diary.fromJson(e)).toList();
        _sortDiaries(); // 일기 목록을 정렬
      });
      widget.onDiariesLoaded(_diaries);
    }
  }

  void _onRefresh() async {
    await _loadDiaries();
    _refreshController.refreshCompleted();
  }

  void _updateDiary(Diary updatedDiary) {
    setState(() {
      int index =
          _diaries.indexWhere((element) => element.id == updatedDiary.id);
      if (index != -1) {
        _diaries[index] = updatedDiary;
      }
    });
    saveUpdatedDiaries();
  }

  Future<void> saveUpdatedDiaries() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/diaries.json');
      await file
          .writeAsString(json.encode(_diaries.map((e) => e.toJson()).toList()));
    } catch (e) {
      print('Error saving diaries: $e');
    }
  }

  void refreshDiaries() {
    _loadDiaries();
  }

  void _deleteDiary(Diary diary) {
    setState(() {
      _diaries.remove(diary);
      saveUpdatedDiaries();
    });
  }

  void _sortDiaries() {
    _diaries.sort((a, b) =>
        _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date));
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
          title: const Text('일기 목록'),
          backgroundColor: theme.primaryColor,
          titleTextStyle: TextStyle(color: textColor),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.sort, color: textColor),
              onSelected: (value) {
                setState(() {
                  if (value == 'asc') {
                    _isAscending = true;
                  } else if (value == 'desc') {
                    _isAscending = false;
                  }
                  _sortDiaries();
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'asc',
                  child: Text('날짜 오름차순'),
                ),
                const PopupMenuItem(
                  value: 'desc',
                  child: Text('날짜 내림차순'),
                ),
              ],
            ),
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
            itemCount: _diaries.length,
            itemBuilder: (context, index) {
              Diary diary = _diaries[index];
              return ListTile(
                title: Text(diary.title, style: TextStyle(color: textColor)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(diary.content, style: TextStyle(color: textColor)),
                    if (diary.location != null)
                      InkWell(
                        onTap: () {
                          _openLocationInMaps(diary.location!);
                        },
                        child: Text(
                          'View location on Google Maps',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(diary.date),
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                        Text(
                          DateFormat('HH:mm').format(diary.date),
                          style: TextStyle(fontSize: 12, color: textColor),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDiaryScreen(
                                diary: diary,
                                onUpdate: _updateDiary,
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Diary'),
                              content: const Text('이 일기를 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteDiary(diary);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiaryDetailScreen(
                        diary: diary,
                        onDelete: _deleteDiary,
                        onUpdate: _updateDiary,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openLocationInMaps(String location) {
    if (location.isNotEmpty) {
      launch(location);
    }
  }
}

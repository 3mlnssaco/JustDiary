import 'package:flutter/material.dart';
import 'diary_list_screen.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import 'write_diary_screen.dart';
import 'diary_search_delegate.dart';
import 'diary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  List<Diary> _diaries = [];
  final GlobalKey<DiaryListScreenState> _diaryListKey =
      GlobalKey<DiaryListScreenState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      DiaryListScreen(
        key: _diaryListKey,
        onDiariesLoaded: (diaries) {
          setState(() {
            _diaries = diaries;
          });
        },
      ),
      CalendarScreen(
        onDelete: (diary) {
          setState(() {
            _diaries.remove(diary);
            _diaryListKey.currentState?.refreshDiaries();
          });
        },
        onUpdate: (diary) {
          setState(() {
            int index = _diaries.indexWhere((d) => d.id == diary.id);
            if (index != -1) {
              _diaries[index] = diary;
              _diaryListKey.currentState?.refreshDiaries();
            }
          });
        },
      ),
      SettingScreen(),
    ];
  }

  List<Widget> _pages = [];

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _navigateToWriteDiaryScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteDiaryScreen(),
      ),
    );
    if (result == true) {
      setState(() {
        _selectedTabIndex = 1;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _selectedTabIndex = 0;
      });
    }
  }

  void _onSearchPressed() {
    showSearch(
      context: context,
      delegate: DiarySearchDelegate(
        diaries: _diaries,
        onDelete: (diary) {
          setState(() {
            _diaries.remove(diary);
            _diaryListKey.currentState?.refreshDiaries();
          });
        },
        onUpdate: (diary) {
          setState(() {
            int index = _diaries.indexWhere((d) => d.id == diary.id);
            if (index != -1) {
              _diaries[index] = diary;
              _diaryListKey.currentState?.refreshDiaries();
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchPressed,
          ),
        ],
      ),
      body: _pages.isNotEmpty ? _pages[_selectedTabIndex] : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '일기 목록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '환경설정',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToWriteDiaryScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

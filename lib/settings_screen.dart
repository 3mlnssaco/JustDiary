import 'package:flutter/material.dart'; // Flutter UI 프레임워크
import 'package:provider/provider.dart'; // 상태 관리를 위한 Provider 패키지
import 'package:shared_preferences/shared_preferences.dart'; // 로컬 저장소를 위한 SharedPreferences 패키지
import 'dart:math'; // 랜덤 테마 생성을 위한 math 패키지

import 'theme_notifier.dart'; // 테마 상태 관리를 위한 파일
import 'main.dart'; // scheduleAlarm 함수를 사용하기 위해 추가

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key); // 기본 생성자

  @override
  _SettingScreenState createState() => _SettingScreenState(); // 상태 클래스 생성
}

class _SettingScreenState extends State<SettingScreen> {
  ThemeData? _selectedTheme; // 선택된 테마를 저장할 변수
  bool _isLoading = true; // 로딩 상태를 나타내는 변수
  TimeOfDay _selectedTime = TimeOfDay(hour: 17, minute: 0); // 알람 시간을 저장할 변수

  final List<ThemeData> _themes = [
    // 테마 목록을 저장하는 리스트
    ThemeData(
      scaffoldBackgroundColor: Colors.white, // 배경색 설정
      primaryColor: Colors.blue, // 주 색상 설정
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.orange), // 색상 스키마 설정
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.blue), // 큰 텍스트 색상 설정
        bodyMedium: TextStyle(color: Colors.black), // 중간 텍스트 색상 설정
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue, // 앱바 배경색 설정
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: 20), // 앱바 타이틀 텍스트 스타일 설정
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.blue, // 하단 네비게이션 바 배경색 설정
        selectedItemColor: Colors.orange, // 선택된 아이템 색상 설정
        unselectedItemColor: Colors.white, // 선택되지 않은 아이템 색상 설정
      ),
    ),
    // 다른 테마들 설정 (생략된 부분 포함)
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFEBCD),
      primaryColor: const Color(0xFFFF6347),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFD700)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFF6347)),
        bodyMedium: TextStyle(color: Color(0xFFFFA07A)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF6347),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFF6347),
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFAFAD2),
      primaryColor: const Color(0xFF00FA9A),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF20B2AA)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF00FA9A)),
        bodyMedium: TextStyle(color: Color(0xFF20B2AA)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00FA9A),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF00FA9A),
        selectedItemColor: Color(0xFF20B2AA),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFFACD),
      primaryColor: const Color(0xFFFFA07A),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF4500)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFFA07A)),
        bodyMedium: TextStyle(color: Color(0xFFFF4500)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFA07A),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFA07A),
        selectedItemColor: Color(0xFFFF4500),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFE4B5),
      primaryColor: const Color(0xFFCD853F),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFD2691E)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFCD853F)),
        bodyMedium: TextStyle(color: Color(0xFFD2691E)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFCD853F),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFCD853F),
        selectedItemColor: Color(0xFFD2691E),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF0F8FF),
      primaryColor: const Color(0xFF4682B4),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF5F9EA0)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF4682B4)),
        bodyMedium: TextStyle(color: Color(0xFF5F9EA0)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4682B4),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF4682B4),
        selectedItemColor: Color(0xFF5F9EA0),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFE4E1),
      primaryColor: const Color(0xFF8A2BE2),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF69B4)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF8A2BE2)),
        bodyMedium: TextStyle(color: Color(0xFFFF69B4)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8A2BE2),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF8A2BE2),
        selectedItemColor: Color(0xFFFF69B4),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFF5EE),
      primaryColor: const Color(0xFFFF7F50),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF20B2AA)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFF7F50)),
        bodyMedium: TextStyle(color: Color(0xFF20B2AA)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF7F50),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFF7F50),
        selectedItemColor: Color(0xFF20B2AA),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFEEE8AA),
      primaryColor: const Color(0xFF9370DB),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFE6E6FA)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF9370DB)),
        bodyMedium: TextStyle(color: Color(0xFFE6E6FA)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF9370DB),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF9370DB),
        selectedItemColor: Color(0xFFE6E6FA),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFFDD0),
      primaryColor: const Color(0xFFFFD700),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFF4500)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFFD700)),
        bodyMedium: TextStyle(color: Color(0xFFFF4500)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFD700),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFFD700),
        selectedItemColor: Color(0xFFFF4500),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFE5B4),
      primaryColor: const Color(0xFFFF6347),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFA07A)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFF6347)),
        bodyMedium: TextStyle(color: Color(0xFFFFA07A)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF6347),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFFF6347),
        selectedItemColor: Color(0xFFFFA07A),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF5FFFA),
      primaryColor: const Color(0xFF98FF98),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF3CB371)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF98FF98)),
        bodyMedium: TextStyle(color: Color(0xFF3CB371)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF98FF98),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF98FF98),
        selectedItemColor: Color(0xFF3CB371),
        unselectedItemColor: Colors.white,
      ),
    ),
    ThemeData(
      scaffoldBackgroundColor: const Color(0xFF87CEEB),
      primaryColor: const Color(0xFF00BFFF),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF1E90FF)),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF00BFFF)),
        bodyMedium: TextStyle(color: Color(0xFF1E90FF)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF00BFFF),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF00BFFF),
        selectedItemColor: Color(0xFF1E90FF),
        unselectedItemColor: Colors.white,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadTheme(); // 테마 로드 함수 호출
    _loadSavedTime(); // 저장된 알람 시간 로드 함수 호출
  }

  void _loadTheme() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 가져오기
    bool isClassicMode =
        prefs.getBool('isClassicMode') ?? true; // 저장된 테마 모드 가져오기
    setState(() {
      _selectedTheme =
          isClassicMode ? _themes[0] : ThemeData.light(); // 선택된 테마 설정
      _isLoading = false; // 로딩 상태 해제
    });
  }

  void _loadSavedTime() async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 가져오기
    final hour = prefs.getInt('alarm_hour') ?? 17; // 저장된 알람 시간 (시) 가져오기
    final minute = prefs.getInt('alarm_minute') ?? 0; // 저장된 알람 시간 (분) 가져오기
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute); // 선택된 시간 설정
    });
  }

  void _saveTime(TimeOfDay time) async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 가져오기
    await prefs.setInt('alarm_hour', time.hour); // 알람 시간 (시) 저장
    await prefs.setInt('alarm_minute', time.minute); // 알람 시간 (분) 저장
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime, // 초기 시간 설정
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked; // 선택된 시간 설정
      });
      _saveTime(picked); // 선택된 시간 저장
      final now = DateTime.now(); // 현재 시간 가져오기
      final scheduledTime = DateTime(now.year, now.month, now.day, picked.hour,
          picked.minute); // 선택된 시간에 대한 DateTime 객체 생성
      scheduleAlarm(scheduledTime); // 알람 스케줄 함수 호출
    }
  }

  void _toggleTheme() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 인스턴스 가져오기
    setState(() {
      prefs.setBool('isClassicMode', true); // 클래식 모드로 설정
      _selectedTheme = _themes[0]; // 선택된 테마 설정
      _isLoading = false; // 로딩 상태 해제
      final themeNotifier =
          Provider.of<ThemeNotifier>(context, listen: false); // 테마 노티파이어 가져오기
      themeNotifier.setTheme(_selectedTheme!); // 테마 변경 알림
    });
  }

  void _randomTheme() {
    final random = Random(); // 랜덤 인스턴스 생성
    setState(() {
      _selectedTheme = _themes[random.nextInt(_themes.length)]; // 랜덤으로 테마 선택
      _isLoading = false; // 로딩 상태 해제
      final themeNotifier =
          Provider.of<ThemeNotifier>(context, listen: false); // 테마 노티파이어 가져오기
      themeNotifier.setTheme(_selectedTheme!); // 테마 변경 알림
    });
  }

  void _changeTheme(ThemeData theme) {
    setState(() {
      _selectedTheme = theme; // 선택된 테마 설정
      _isLoading = false; // 로딩 상태 해제
      final themeNotifier =
          Provider.of<ThemeNotifier>(context, listen: false); // 테마 노티파이어 가져오기
      themeNotifier.setTheme(_selectedTheme!); // 테마 변경 알림
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // 로딩 중일 때
      return const Center(child: CircularProgressIndicator()); // 로딩 스피너 표시
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // 앱바 제목 설정
        backgroundColor: _selectedTheme!.primaryColor, // 앱바 배경색 설정
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _selectedTheme!.primaryColor!, // 그라데이션 색상 설정
              _selectedTheme!.colorScheme.secondary!,
              _selectedTheme!.scaffoldBackgroundColor!
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                  '알람 시간 설정: ${_selectedTime.format(context)}'), // 알람 시간 텍스트 표시
              onTap: () => _selectTime(context), // 클릭 시 시간 선택 함수 호출
            ),
            ListTile(
              title: const Text('Random Theme'), // 랜덤 테마 텍스트
              onTap: _randomTheme, // 클릭 시 랜덤 테마 설정 함수 호출
            ),
            ListTile(
              title: const Text('Toggle Classic Theme'), // 클래식 테마 전환 텍스트
              onTap: _toggleTheme, // 클릭 시 클래식 테마 전환 함수 호출
            ),
            ListTile(
              title: const Text('Sunset Theme'), // 선셋 테마 텍스트
              onTap: () => _changeTheme(_themes[1]), // 클릭 시 선셋 테마 설정
            ),
            ListTile(
              title: const Text('Spring Theme'), // 스프링 테마 텍스트
              onTap: () => _changeTheme(_themes[2]), // 클릭 시 스프링 테마 설정
            ),
            ListTile(
              title: const Text('Summer Theme'), // 썸머 테마 텍스트
              onTap: () => _changeTheme(_themes[3]), // 클릭 시 썸머 테마 설정
            ),
            ListTile(
              title: const Text('Autumn Theme'), // 어텀 테마 텍스트
              onTap: () => _changeTheme(_themes[4]), // 클릭 시 어텀 테마 설정
            ),
            ListTile(
              title: const Text('Winter Theme'), // 윈터 테마 텍스트
              onTap: () => _changeTheme(_themes[5]), // 클릭 시 윈터 테마 설정
            ),
            ListTile(
              title: const Text('Rainbow Theme'), // 레인보우 테마 텍스트
              onTap: () => _changeTheme(_themes[6]), // 클릭 시 레인보우 테마 설정
            ),
            ListTile(
              title: const Text('Coral Reef Theme'), // 코랄 리프 테마 텍스트
              onTap: () => _changeTheme(_themes[7]), // 클릭 시 코랄 리프 테마 설정
            ),
            ListTile(
              title: const Text('Lavender Fields Theme'), // 라벤더 필드 테마 텍스트
              onTap: () => _changeTheme(_themes[8]), // 클릭 시 라벤더 필드 테마 설정
            ),
            ListTile(
              title: const Text('Sunrise Theme'), // 선라이즈 테마 텍스트
              onTap: () => _changeTheme(_themes[9]), // 클릭 시 선라이즈 테마 설정
            ),
            ListTile(
              title: const Text('Peach Theme'), // 피치 테마 텍스트
              onTap: () => _changeTheme(_themes[10]), // 클릭 시 피치 테마 설정
            ),
            ListTile(
              title: const Text('Mint Theme'), // 민트 테마 텍스트
              onTap: () => _changeTheme(_themes[11]), // 클릭 시 민트 테마 설정
            ),
            ListTile(
              title: const Text('Sky Blue Theme'), // 스카이 블루 테마 텍스트
              onTap: () => _changeTheme(_themes[12]), // 클릭 시 스카이 블루 테마 설정
            ),
          ],
        ),
      ),
    );
  }
}

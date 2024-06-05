import 'dart:convert'; // JSON 인코딩 및 디코딩을 위해 사용
import 'dart:io'; // 파일 작업을 위해 사용
import 'package:flutter/material.dart'; // Flutter UI 프레임워크
import 'package:intl/intl.dart'; // 날짜 형식을 위해 사용
import 'package:path_provider/path_provider.dart'; // 로컬 파일 시스템 경로 제공
import 'package:geolocator/geolocator.dart'; // 위치 정보를 얻기 위해 사용
import 'package:uuid/uuid.dart'; // UUID 생성 라이브러리
import 'package:image_picker/image_picker.dart'; // 이미지 선택 라이브러리
import 'diary.dart'; // Diary 모델 가져오기

class WriteDiaryScreen extends StatefulWidget {
  const WriteDiaryScreen({super.key}); // 기본 생성자

  @override
  _WriteDiaryScreenState createState() => _WriteDiaryScreenState(); // 상태 클래스 생성
}

class _WriteDiaryScreenState extends State<WriteDiaryScreen> {
  final TextEditingController _titleController =
      TextEditingController(); // 제목 입력 컨트롤러
  final TextEditingController _contentController =
      TextEditingController(); // 내용 입력 컨트롤러
  String _selectedFont = 'Roboto'; // 선택된 폰트 초기값
  double _fontSize = 16.0; // 글자 크기 초기값
  DateTime _selectedDate = DateTime.now(); // 선택된 날짜 초기값
  String? _currentAddress; // 현재 주소 저장 변수
  File? _selectedImage; // 선택한 이미지 파일 변수

  final ImagePicker _picker = ImagePicker(); // 이미지 선택기 인스턴스 생성

  // 날짜 및 시간 선택 함수
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // 현재 위치 정보 얻기 함수
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled; // 위치 서비스 활성화 여부
    LocationPermission permission; // 위치 권한

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화 여부 확인
    if (!serviceEnabled) {
      return Future.error(
          'Location services are disabled.'); // 위치 서비스가 비활성화된 경우 에러 반환
    }

    permission = await Geolocator.checkPermission(); // 위치 권한 확인
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // 권한 요청
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied.'); // 권한 거부 시 에러 반환
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'); // 영구적으로 권한 거부 시 에러 반환
    }

    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high); // 현재 위치 정보 얻기
    setState(() {
      _currentAddress =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}'; // 현재 위치 주소 저장
    });
  }

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // 선택한 이미지 파일 저장
      });
    }
  }

  // 일기 저장 함수
  void _saveDiary() async {
    try {
      var uuid = const Uuid(); // UUID 인스턴스 생성
      Diary newDiary = Diary(
        id: uuid.v4(), // 고유 ID 생성
        title: _titleController.text, // 제목 설정
        content: _contentController.text, // 내용 설정
        font: _selectedFont, // 폰트 설정
        fontSize: _fontSize, // 글자 크기 설정
        date: _selectedDate, // 날짜 설정
        location: _currentAddress, // 위치 정보 설정
        imagePath: _selectedImage?.path, // 이미지 경로 설정
      );

      Directory directory =
          await getApplicationDocumentsDirectory(); // 앱 문서 디렉토리 경로 얻기
      File file = File('${directory.path}/diaries.json'); // 일기 저장 파일 경로

      List<Diary> diaries = []; // 일기 목록 초기화
      if (await file.exists()) {
        String jsonString = await file.readAsString(); // 파일 읽기
        List<dynamic> jsonList = json.decode(jsonString); // JSON 디코딩
        diaries =
            jsonList.map((e) => Diary.fromJson(e)).toList(); // 일기 객체 리스트로 변환
      }

      // 새로운 일기를 기존 일기 목록에 추가
      diaries.add(newDiary);

      // 기존 파일을 덮어쓰는 대신 일기 목록 전체를 다시 저장
      await file
          .writeAsString(json.encode(diaries.map((e) => e.toJson()).toList()));

      // 저장 후 화면을 종료
      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving diary: $e'); // 에러 발생 시 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 작성'), // 앱 바 제목
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로 가기 아이콘
          onPressed: () {
            _showExitConfirmationDialog(context); // 뒤로 가기 버튼 클릭 시 확인 다이얼로그 표시
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), // 저장 아이콘
            onPressed: _saveDiary, // 저장 버튼 클릭 시 일기 저장
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 패딩 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            TextField(
              controller: _titleController, // 제목 입력 필드
              decoration: const InputDecoration(
                hintText: '제목',
              ),
            ),
            const SizedBox(height: 16.0), // 여백
            DropdownButtonFormField(
              value: _selectedFont, // 선택된 폰트
              items: [
                'Roboto',
                '210 Ojunohwhoo L',
                '210 시골밥상L',
                'HGSS',
                'HoonSlimskinnyL',
                'SangSangFlowerRoad',
                'SangSangShinb7',
                'THE블랙잭L',
                'tvN Enjoystories Light',
                'Typo_CrayonM'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(), // 폰트 목록
              onChanged: (value) {
                setState(() {
                  _selectedFont = value.toString(); // 선택된 폰트 업데이트
                });
              },
            ),
            const SizedBox(height: 16.0), // 여백
            Row(
              children: [
                const Text('글자 크기: '), // 글자 크기 텍스트
                const SizedBox(width: 8.0), // 여백
                Expanded(
                  child: TextFormField(
                    initialValue: _fontSize.toString(), // 초기 글자 크기 값
                    keyboardType: TextInputType.number, // 숫자 입력 타입
                    onChanged: (value) {
                      setState(() {
                        _fontSize = double.parse(value); // 글자 크기 업데이트
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // 여백
            Row(
              children: [
                const Text('작성 날짜 및 시간: '), // 날짜 및 시간 텍스트
                const SizedBox(width: 8.0), // 여백
                Text(DateFormat('yyyy-MM-dd HH:mm')
                    .format(_selectedDate)), // 선택된 날짜 및 시간
                IconButton(
                  icon: const Icon(Icons.calendar_today), // 달력 아이콘
                  onPressed: () =>
                      _selectDateTime(context), // 달력 아이콘 클릭 시 날짜 선택 함수 호출
                ),
              ],
            ),
            const SizedBox(height: 16.0), // 여백
            Row(
              children: [
                ElevatedButton(
                  onPressed: _getCurrentLocation, // 위치 추가 버튼 클릭 시 위치 얻기 함수 호출
                  child: const Text('위치 추가'),
                ),
                const SizedBox(width: 8.0), // 여백
                if (_currentAddress != null)
                  const Expanded(
                    child: Text(
                      '위치 추가됨', // 위치 추가됨 텍스트
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16.0), // 여백
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(
                    _selectedImage!, // 선택된 이미지 파일 표시
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0), // 여백
                ],
              ),
            ElevatedButton(
              onPressed: _pickImage, // 사진 선택 버튼 클릭 시 이미지 선택 함수 호출
              child: const Text('사진 선택'),
            ),
            const SizedBox(height: 16.0), // 여백
            Expanded(
              child: TextField(
                controller: _contentController, // 내용 입력 필드
                decoration: const InputDecoration(
                  hintText: '일기 내용',
                ),
                maxLines: null, // 최대 줄 수 제한 없음
                style: TextStyle(
                  fontSize: _fontSize, // 글자 크기 설정
                  fontFamily: _selectedFont, // 폰트 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 일기 작성 종료 확인 다이얼로그 표시 함수
  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 바깥쪽 터치로 닫기 불가
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('일기 작성 종료'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('작성 중인 일기가 저장되지 않습니다.'), // 경고 메시지
                Text('정말 종료하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'), // 아니오 버튼
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('예'), // 예 버튼
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 화면 닫기
              },
            ),
          ],
        );
      },
    );
  }
}

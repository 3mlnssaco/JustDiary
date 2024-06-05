import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io'; // File 클래스 사용을 위해 추가
import 'diary.dart'; // 일기 모델을 가져옴
import 'edit_diary_screen.dart'; // 일기 수정 화면을 가져옴

class DiaryDetailScreen extends StatelessWidget {
  final Diary diary; // Diary 객체
  final Function(Diary) onDelete; // 삭제 콜백 함수
  final Function(Diary) onUpdate; // 업데이트 콜백 함수

  const DiaryDetailScreen({
    super.key,
    required this.diary,
    required this.onDelete,
    required this.onUpdate,
  }); // 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diary.title), // 앱 바의 제목을 일기 제목으로 설정
        actions: [
          IconButton(
            icon: const Icon(Icons.delete), // 삭제 아이콘
            onPressed: () {
              // 삭제 확인 팝업 표시
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('일기 삭제'),
                  content: const Text('이 일기를 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 팝업 닫기
                      },
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete(diary); // 삭제 콜백 호출
                        Navigator.pop(context); // 팝업 닫기
                        Navigator.pop(context); // 현재 화면 닫기
                      },
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (diary.imagePath != null &&
                diary.imagePath!.isNotEmpty) // 이미지 경로가 있는 경우
              Column(
                children: [
                  Image.file(
                    File(diary.imagePath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            Text(
              diary.content,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(diary.date),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            if (diary.location != null)
              InkWell(
                onTap: () {
                  _openLocationInMaps(diary.location!);
                },
                child: const Text(
                  'Google Maps에서 위치 보기',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditDiaryScreen(
                diary: diary,
                onUpdate: onUpdate,
              ),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

void _openLocationInMaps(String location) {
  if (location.isNotEmpty) {
    launch(location);
  }
}

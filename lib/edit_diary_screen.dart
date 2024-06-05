import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // 이미지 선택 패키지 추가
import 'diary.dart';
import 'dart:io'; // File 클래스 사용을 위해 추가

class EditDiaryScreen extends StatefulWidget {
  final Diary diary;
  final Function(Diary) onUpdate;

  const EditDiaryScreen(
      {super.key, required this.diary, required this.onUpdate});

  @override
  _EditDiaryScreenState createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;
  String _selectedFont = 'Roboto';
  double _fontSize = 16.0;
  File? _selectedImage; // 선택한 이미지 파일을 저장할 변수

  final ImagePicker _picker = ImagePicker(); // 이미지 선택기 인스턴스

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.diary.title);
    _contentController = TextEditingController(text: widget.diary.content);
    _selectedDate = widget.diary.date;
    _selectedFont = widget.diary.font;
    _fontSize = widget.diary.fontSize;
  }

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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _updateDiary() {
    Diary updatedDiary = Diary(
      id: widget.diary.id, // id 필드 추가
      title: _titleController.text,
      content: _contentController.text,
      font: _selectedFont,
      fontSize: _fontSize,
      date: _selectedDate,
      location: widget.diary.location, // 위치 정보 유지
      imagePath: _selectedImage?.path, // 이미지 경로 추가
    );
    widget.onUpdate(updatedDiary);
    Navigator.pop(context, true); // 수정된 일기를 반환합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 수정하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateDiary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '제목',
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField(
              value: _selectedFont,
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
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFont = value.toString();
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('글자 크기: '),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    initialValue: _fontSize.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = double.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('작성 날짜 및 시간: '),
                const SizedBox(width: 8.0),
                Text(DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate)),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_selectedImage != null)
              Column(
                children: [
                  Image.file(
                    _selectedImage!,
                    height: 200,
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('사진 선택'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: '일기 내용',
                ),
                maxLines: null,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontFamily: _selectedFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

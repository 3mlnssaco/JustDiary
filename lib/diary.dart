class Diary {
  final String id;
  final String title;
  final String content;
  final String font;
  final double fontSize;
  final DateTime date;
  final String? location;
  final String? imagePath; // 이미지 경로 추가

  Diary({
    required this.id,
    required this.title,
    required this.content,
    required this.font,
    required this.fontSize,
    required this.date,
    this.location,
    this.imagePath, // 이미지 경로 초기화
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      font: json['font'],
      fontSize: json['fontSize'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'font': font,
      'fontSize': fontSize,
      'date': date.toIso8601String(),
      'location': location,
      'imagePath': imagePath,
    };
  }
}

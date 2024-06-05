import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'diary_list_screen.dart';
import 'diary.dart'; // Diary 모델을 가져옴

class KakaoLoginPage extends StatefulWidget {
  const KakaoLoginPage({super.key});

  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {

  @override
  void initState() {
    super.initState();
    _loginWithKakao();
  }

  Future<void> _loginWithKakao() async {
    try {
      // Check if KakaoTalk is installed, then try login with KakaoTalk first
      if (await isKakaoTalkInstalled()) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
        } catch (e) {
          // If login with KakaoTalk fails, try with Kakao account
          await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // On successful login, navigate to DiaryListScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryListScreen(
            onDiariesLoaded: (List<Diary> diaries) {
              // Add necessary logic here, for example, logging output
            },
          ),
        ),
      );
    } catch (e) {
      // Handle login failure and show a dialog or toast to the user
      _showErrorDialog(context, '카카오 로그인 실패: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao Login'),
      ),
      body: const Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator while logging in
      ),
    );
  }
}

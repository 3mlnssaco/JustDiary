import 'package:flutter/material.dart';
import 'diary.dart';
import 'diary_detail_screen.dart';

class DiarySearchDelegate extends SearchDelegate {
  final List<Diary> diaries;
  final Function(Diary) onUpdate;
  final Function(Diary) onDelete;

  DiarySearchDelegate(
      {required this.diaries, required this.onUpdate, required this.onDelete});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Diary> matchQuery = [];
    for (var diary in diaries) {
      if (diary.title.contains(query) || diary.content.contains(query)) {
        matchQuery.add(diary);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.title),
          subtitle: Text(result.content),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiaryDetailScreen(
                  diary: result,
                  onDelete: onDelete,
                  onUpdate: onUpdate,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Diary> matchQuery = [];
    for (var diary in diaries) {
      if (diary.title.contains(query) || diary.content.contains(query)) {
        matchQuery.add(diary);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.title),
        );
      },
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_questions/config/user_chooses.dart';
import 'package:trivia_questions/pages/choose_page.dart';



class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {

  late final String _timer;
  late final String _results;
  String resultsCategory = 'category: ${quizCategory.entries.firstWhere((MapEntry<String, String> element) => element.value == selectedCategory,).key}';
  String resultsDifficulty = 'difficult: ${quizDifficulty.entries.firstWhere((MapEntry<String, String> element) => element.value == selectedDifficulty,).key}';
  String resultsType = 'type of questions: ${quizType.entries.firstWhere((MapEntry<String, String> element) => element.value == selectedType,).key}';

  final Completer<void> _preferencesReady = Completer<void>();

 Future<void> _updateCache() async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   final String? timerFromCache = prefs.getString('timer');
   final String? resultsFromCache = prefs.getString('results');
   setState(() {
     _timer = timerFromCache!;
     _results = resultsFromCache!;
   });
   _preferencesReady.complete();
 }
  Future<void> _onShare(BuildContext context) async {

    await SharePlus.instance.share(
        ShareParams(
          text: '$_timer, $_results, $resultsCategory, $resultsDifficulty, $resultsType beat it!',),
    );
  }
  @override
  void initState() {
    super.initState();
    _updateCache();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd:(DragEndDetails details){
          final double velocity = details.velocity.pixelsPerSecond.dx;
          if (velocity > 350) {
            context.go('/');
          }
        },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.go('/'), icon: const Icon(Icons.home)),
        title: const Text('Results'),
        actions: <Widget>[
          ElevatedButton(onPressed:() {_onShare(context);}, child: const Icon(Icons.share))
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Text('time: $_timer'),
            Text('Count of questions: $selectedAmountForResults'),
            Text(_results),
            Text(resultsCategory),
            Text(resultsDifficulty),
            Text(resultsType),
            const SizedBox(height: 15,),
            //const Text('Questions and answers is below'),

            //const QuestionAndAnswer(),
          ]
      ),
    ),
    )
    );
  }
}

class QuestionAndAnswer extends StatelessWidget {
  const QuestionAndAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> quizStatistics = questionsAndAnswers.map((final String qa) => Card(
      shadowColor: Colors.white70,surfaceTintColor: Colors.white,elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: HtmlWidget('$qa <br><br>'),)).toList();
    return Column(children: quizStatistics);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_questions/config/database_functions.dart';
import 'package:trivia_questions/config/user_chooses.dart';
import 'package:trivia_questions/json_getter/quiz_getter.dart';


Future<void> _updateTimerCache(final String timerEnd) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('timer', timerEnd);
}

Future<void> _updateResultsCache(final String endResults) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('results', endResults);
}
Future<void> _updateQuizBlocksCache(final List<String> endResults) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('quizBlocks', endResults);
}
int incorrectCount = 0;
int correctCount = 0;


void _resultsCount(final int answers){
  if (answers == -1) {
    incorrectCount++;
  } else if (answers == 1) {
    correctCount++;
  }
}

class QuestionBuilder extends StatefulWidget {
  const QuestionBuilder({super.key});

  @override
  State<QuestionBuilder> createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  late final Future<QuizResponse> _quizFuture;
  Timer? timer;
  int _seconds = 0;
  late Key timerKey = UniqueKey();

  void _startTimer() {
    if (timer != null && timer!.isActive) {
      return;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
        timerKey = UniqueKey();
      });
    });
  }

  void _stopTimer(){
    timer?.cancel();
    setState((){
      _seconds = 0;
    });
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    correctCount = 0;
    incorrectCount = 0;
    _quizFuture = fetchQuiz();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _startTimer();
    return GestureDetector(
      onHorizontalDragEnd:(DragEndDetails details){
        final double velocity = details.velocity.pixelsPerSecond.dx;
        if (velocity > 400) {
        context.go('/');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){context.go('/');}, icon: const Icon(Icons.arrow_back)),
          title: const Text('Quiz!'),
          actions: <Widget>[Text(key: timerKey,_formatTime(_seconds))],
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
      body: FutureBuilder<QuizResponse>(
        future: _quizFuture,
        builder: (BuildContext context, AsyncSnapshot<QuizResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final List<QuizQuestion> questions = snapshot.data!.results;
            return ListView(
              children: <Widget>[
                ...questions.map(
                      (final QuizQuestion q) =>
                          Card(
                            key: ValueKey<String>(q.question),
                            shadowColor: Colors.white70,surfaceTintColor: Colors.white,elevation: 10,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child:ListTile(
                    title: HtmlWidget(q.question),
                    subtitle: QuizSort(
                      question: q.question,
                      correctAnswer: q.correctAnswer,
                      incorrectAnswers: q.incorrectAnswers,
                    ),
                  ),
          )
                ),
                ElevatedButton(
                  onPressed: () => <void>{
                    _updateTimerCache(_formatTime(_seconds)),
                    _updateResultsCache('correct answers: $correctCount, incorrect answers: $incorrectCount'),
                    _updateQuizBlocksCache(questionsAndAnswers),
                    questionsAndAnswers = <String>[],
                    _stopTimer(),
                    context.go('results')},
                  child: const Text('Results!'),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    )
    );
  }
}

class QuizSort extends StatefulWidget {
  const QuizSort({
    super.key,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.question,
  });

  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String question;

  @override
  State<QuizSort> createState() => _QuizSortState();
}

class _QuizSortState extends State<QuizSort> with AutomaticKeepAliveClientMixin{
  late final List<String> _answers;
  int? _selectedIndex; // индекс выбранного ответа, null - ещё не отвечали


  @override
  void initState() {
    super.initState();
    // считаем список и сортируем один раз, а не при каждом build
    _answers = List<String>.from(widget.incorrectAnswers)
      ..add(widget.correctAnswer)
      ..sort((String a, String b) => b.length.compareTo(a.length));
  }

  void _onAnswerTap(int index) {
    if (_selectedIndex != null) {
      return; // уже отвечали - игнорируем повторные нажатия
    }
    else{
    setState(() {
      _selectedIndex = index;

      if(_answers[_selectedIndex!] == widget.correctAnswer){
        _resultsCount(1);
      questionsAndAnswers.add('${widget.question}: ${_answers[_selectedIndex!]} : correct');
      changeDB('${DateTime.now()}', widget.question, _answers[_selectedIndex!], 'correct');
      }
      else if(widget.incorrectAnswers.contains(_answers[_selectedIndex!]))
        {
          _resultsCount(-1);
          questionsAndAnswers.add('${widget.question}: ${_answers[_selectedIndex!]} : incorrect');
          changeDB('${DateTime.now()}', widget.question, _answers[_selectedIndex!], 'incorrect');
        }
    });}
  }

  @override
  bool get wantKeepAlive => true; // сохранять состояние

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool answered = _selectedIndex != null;

    return Column(
      children: List<Widget>.generate(_answers.length, (int i) {
        final String answerText = _answers[i];
        final bool isCorrect = answerText == widget.correctAnswer;
        final bool isSelected = _selectedIndex == i;

        Color? backgroundColor;
        if (answered) {
          if (isCorrect) {
            backgroundColor = Colors.green.withValues(alpha: 0.3);
          } else if (isSelected) {
            backgroundColor = Colors.red.withValues(alpha: 0.3);
          }
        }

        return TextButton(
          // деактивируем кнопку после ответа
          onPressed: answered ? null : () => _onAnswerTap(i),
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            disabledForegroundColor: Colors.blue,
          ),
          child: HtmlWidget(answerText),
        );
      }),
    );
  }
}

Future<QuizResponse> fetchQuiz() async {
  final http.Response response = await http.get(
    Uri.parse(
      'https://opentdb.com/api.php?amount=$selectedAmount&$selectedCategory&difficulty=$selectedDifficulty&type=$selectedType',
    ),
  );

  if (response.statusCode == 200) {
    return QuizResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  throw Exception('something wrong, i can feel it');
}

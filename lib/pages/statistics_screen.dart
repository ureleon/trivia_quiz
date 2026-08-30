import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:trivia_questions/config/database_functions.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final TextEditingController _controller;
  String? userInput;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    userInput = '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd:(DragEndDetails details){
          final double velocity = details.velocity.pixelsPerSecond.dx;
          if (velocity > 500) {
            context.go('/');
          }
        },
        child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            // возвращаемся назад, не теряя историю навигации
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Statistics'),
        ),
        body: Column(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'search'),
                controller: _controller,
                onSubmitted: (String? value) {
                    setState(() {
                      userInput = value;
                    });
                },

              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                future: searchStatistics(userInput!),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
// Показываем индикатор загрузки
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

// Обрабатываем ошибки
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

// Данные получены
                  final List<Map<String, dynamic>>? data = snapshot.data;

// Если данных нет или список пуст
                  if (data == null || data.isEmpty) {
                    return const Center(child: Text('Statistics is empty for now'));
                  }

// Строим список на основе данных
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> record = data[index];
                      return Card(
                          shadowColor: Colors.white70,surfaceTintColor: Colors.white,elevation: 10,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: ListTile(
                        title: HtmlWidget('${record['questions'] ?? 'Question is epson'}'),
                        subtitle: HtmlWidget(
                            'Ответ: ${record['answer']} — ${record['mark']}'),
                        leading: HtmlWidget(record['date'].toString().substring(0,19)),
                      )
                      );
                    },
                  );
                },
              ),
    )
            ]
        )
    )
    );
  }
}

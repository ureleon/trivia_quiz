import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'quiz_getter.g.dart';

@JsonSerializable()
class QuizResponse {

  const QuizResponse({
    required this.responseCode,
    required this.results,
  });

  factory QuizResponse.fromRawJson(final String str) =>
      QuizResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  factory QuizResponse.fromJson(final Map<String, dynamic> json) =>
      QuizResponse(
        responseCode: json['response_code'] as int,
        results: List<QuizQuestion>.from(
          (json['results'] as List<dynamic>).map((final dynamic x) => QuizQuestion.fromJson(x as Map<String, dynamic>)),
        ),
      );
  @JsonKey(name: 'response_code')
  final int responseCode;

  final List<QuizQuestion> results;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
    'response_code': responseCode,
    'results': List<dynamic>.from(results.map((final dynamic x) => x.toJson())),
  };
}

@JsonSerializable()
class QuizQuestion {

  const QuizQuestion({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  factory QuizQuestion.fromRawJson(final String str) =>
      QuizQuestion.fromJson(json.decode(str) as Map<String, dynamic>);

  factory QuizQuestion.fromJson(final Map<String, dynamic> json) =>
      QuizQuestion(
        type: json['type'] as String,
        difficulty: json['difficulty'] as String,
        category: json['category'] as String,
        question: json['question'] as String,
        correctAnswer: json['correct_answer'] as String,
        incorrectAnswers: List<String>.from(json['incorrect_answers'] as List<dynamic>),
      );
  final String type;
  final String difficulty;
  final String category;
  final String question;

  @JsonKey(name: 'correct_answer')
  final String correctAnswer;

  @JsonKey(name: 'incorrect_answers')
  final List<String> incorrectAnswers;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type,
    'difficulty': difficulty,
    'category': category,
    'question': question,
    'correct_answer': correctAnswer,
    'incorrect_answers': List<dynamic>.from(incorrectAnswers),
  };
}

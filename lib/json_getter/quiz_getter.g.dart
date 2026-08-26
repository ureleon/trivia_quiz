// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_getter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizResponse _$QuizResponseFromJson(Map<String, dynamic> json) => QuizResponse(
  responseCode: (json['response_code'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizResponseToJson(QuizResponse instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'results': instance.results,
    };

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
  type: json['type'] as String,
  difficulty: json['difficulty'] as String,
  category: json['category'] as String,
  question: json['question'] as String,
  correctAnswer: json['correct_answer'] as String,
  incorrectAnswers: (json['incorrect_answers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'type': instance.type,
      'difficulty': instance.difficulty,
      'category': instance.category,
      'question': instance.question,
      'correct_answer': instance.correctAnswer,
      'incorrect_answers': instance.incorrectAnswers,
    };

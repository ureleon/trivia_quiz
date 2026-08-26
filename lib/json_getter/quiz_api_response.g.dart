// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_api_response.dart';

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

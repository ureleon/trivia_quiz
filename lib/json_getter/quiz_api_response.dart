import 'package:json_annotation/json_annotation.dart';
import 'package:trivia_questions/json_getter/quiz_getter.dart';

part 'quiz_api_response.g.dart';

@JsonSerializable()
class QuizResponse {

  const QuizResponse({
    required this.responseCode,
    required this.results,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizResponseFromJson(json);
  @JsonKey(name: 'response_code')
  final int responseCode;

  final List<QuizQuestion> results;

  Map<String, dynamic> toJson() => _$QuizResponseToJson(this);
}

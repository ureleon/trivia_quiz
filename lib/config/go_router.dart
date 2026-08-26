import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trivia_questions/pages/choose_page.dart';
import 'package:trivia_questions/pages/question_builder.dart';
import 'package:trivia_questions/pages/results_screen.dart';
import 'package:trivia_questions/pages/settings_page.dart';
import 'package:trivia_questions/pages/statistics_screen.dart';

part 'go_router.g.dart';

@TypedGoRoute<ChooseRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<QuestionsRoute>(path: 'questions'),
    TypedGoRoute<SettingsRoute>(path: 'settings'),
    TypedGoRoute<ResultsRoute>(path: 'results'),
    TypedGoRoute<StatisticsRoute>(path: 'statistics'),

  ],
)
class ChooseRoute extends GoRouteData with $ChooseRoute {
  const ChooseRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    return const ChoosePage();
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(final BuildContext context, final GoRouterState state) {
    return const SettingsPage();
  }
}

class QuestionsRoute extends GoRouteData with $QuestionsRoute{
  const QuestionsRoute();

  @override
  Widget build(BuildContext context, final GoRouterState state){
    return const QuestionBuilder();
  }
}

class ResultsRoute extends GoRouteData with $ResultsRoute{
  const ResultsRoute();

@override
Widget build(BuildContext context, final GoRouterState state){
  return const ResultsScreen();
}
}

class StatisticsRoute extends GoRouteData with $StatisticsRoute{
  const StatisticsRoute();

  @override
  Widget build(BuildContext context, final GoRouterState state){
    return const StatisticsScreen();
  }
}

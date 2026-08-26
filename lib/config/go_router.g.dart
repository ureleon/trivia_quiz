// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$chooseRoute];

RouteBase get $chooseRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: false,
  factory: $ChooseRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'questions',
      hasOverriddenOnExit: false,
      factory: $QuestionsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'settings',
      hasOverriddenOnExit: false,
      factory: $SettingsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'results',
      hasOverriddenOnExit: false,
      factory: $ResultsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'statistics',
      hasOverriddenOnExit: false,
      factory: $StatisticsRoute._fromState,
    ),
  ],
);

mixin $ChooseRoute on GoRouteData {
  static ChooseRoute _fromState(GoRouterState state) => const ChooseRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $QuestionsRoute on GoRouteData {
  static QuestionsRoute _fromState(GoRouterState state) =>
      const QuestionsRoute();

  @override
  String get location => GoRouteData.$location('/questions');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ResultsRoute on GoRouteData {
  static ResultsRoute _fromState(GoRouterState state) => const ResultsRoute();

  @override
  String get location => GoRouteData.$location('/results');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $StatisticsRoute on GoRouteData {
  static StatisticsRoute _fromState(GoRouterState state) =>
      const StatisticsRoute();

  @override
  String get location => GoRouteData.$location('/statistics');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

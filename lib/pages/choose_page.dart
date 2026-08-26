import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_questions/config/theme_controller.dart';
import 'package:trivia_questions/config/user_chooses.dart';
import 'package:trivia_questions/main.dart';

String selectedAmountForResults = '1';

class ChoosePage extends StatefulWidget {
  const ChoosePage({super.key});

  @override
  State<ChoosePage> createState() => _ChoosePageState();

}
typedef MenuEntry = DropdownMenuEntry<String>;

class _ChoosePageState extends State<ChoosePage> {
  //String? selectedCategory;
  //String? selectedDifficulty;
  //String? selectedType;
  late final TextEditingController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    selectedCategory = quizCategory.values.first;
    selectedDifficulty = quizDifficulty.values.first;
    selectedType = quizType.values.first;
    controller = TextEditingController();
  }

  List<MenuEntry> get categoryEntries => quizCategory.entries
      .map((MapEntry<String, String> entry) => DropdownMenuEntry<String>(
    value: entry.value,  // строка ID (например '9')
    label: entry.key,    // название категории
  )).toList();
  
  List<MenuEntry> get difficultyEntries => quizDifficulty.entries
      .map((MapEntry<String, String> entry) => DropdownMenuEntry<String>(
  value: entry.value,
  label: entry.key
  )).toList();

  List<MenuEntry> get typeEntries => quizType.entries
      .map((MapEntry<String, String> entry) => DropdownMenuEntry<String>(
      value: entry.value,
      label: entry.key,
  )).toList();

  Future<void> _updateThemeMode(final int mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('settings', mode);
    setState(() => globalThemeMode = themeMap[mode]!);
  }

  @override
  Widget build(BuildContext context) {

    return ThemeController(
        updateTheme: _updateThemeMode,
        child:Scaffold(
      key: _scaffoldKey,
      drawer:Drawer(
        child: Column(children: <Widget>[
          const Spacer(),
          ElevatedButton(onPressed: (){context.go('/settings'); _scaffoldKey.currentState?.closeDrawer();}, child: const Text('Settings',),),
          ElevatedButton(onPressed: (){context.go('/statistics'); _scaffoldKey.currentState?.closeDrawer();}, child: const Text('Statistics',),),
          const Spacer(),
        ]
        ),
      ),
      appBar: AppBar(
          title: const Text('Trivia Quiz Selection'),
          leading: DrawerButton(onPressed: (){_scaffoldKey.currentState?.openDrawer();}),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(labelText: 'count of questions'),
              controller: controller,
              onSubmitted: (String? value) {
                setState(() {
                  selectedAmount = value;
                });
                selectedAmountForResults = value!;
              },
              onChanged: (String? value) {
                setState(() {
                  selectedAmount = value;
                });
                selectedAmountForResults = value!;
              } ,
            ),
            const SizedBox(height: 24),
            DropdownMenu<String>(
              initialSelection: selectedCategory,
              onSelected: (String? value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              dropdownMenuEntries: categoryEntries,
            ),
            const SizedBox(height: 24),
            DropdownMenu<String>(
              initialSelection: selectedDifficulty,
              onSelected: (String? value) {
                setState(() {
                  selectedDifficulty = value;
                });
              },
              dropdownMenuEntries: difficultyEntries,
            ),
            const SizedBox(height: 24),
            DropdownMenu<String>(
              initialSelection: selectedType,
              onSelected: (String? value) {
                setState(() {
                  selectedType = value;
                });
              },
              dropdownMenuEntries: typeEntries,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/questions'),
              child: const Text('Generate Questions'),
            ),
          ],
        ),
      ),
    )
    );
  }
}

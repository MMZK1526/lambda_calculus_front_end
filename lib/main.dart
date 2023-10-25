import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/constants/my_text.dart';
import 'package:lambda_calculus_front_end/constants/my_themes.dart';
import 'package:lambda_calculus_front_end/controllers/callback_binder.dart';
import 'package:lambda_calculus_front_end/views/introduction_tab.dart';
import 'package:lambda_calculus_front_end/views/type_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyText.title.text,
      theme: MyTheme.defaultTheme.theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  /// The callback binder for the Markdown widgets. It determines the behaviour
  /// for custom links in the Markdown text.
  final _markdownCallbackBinder = CallbackBinder<String>();

  @override
  void initState() {
    _markdownCallbackBinder.withCurrentGroup(MyText.title.text, () {
      // Bind the markdownCallbackBinder to the tabs.
      _markdownCallbackBinder['simulation'] = () {
        _tabController.animateTo(1);
      };
      _markdownCallbackBinder['type-inference'] = () {
        _tabController.animateTo(2);
      };
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _markdownCallbackBinder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.title.text),
        bottom: TabBar(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.book_outlined),
              text: MyText.introTab.text,
            ),
            Tab(
              icon: const Icon(Icons.computer_outlined),
              text: MyText.simTab.text,
            ),
            Tab(
              icon: const Icon(Icons.code_outlined),
              text: MyText.typeTab.text,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              IntroductionTab(markdownCallbackBinder: _markdownCallbackBinder),
              IntroductionTab(markdownCallbackBinder: _markdownCallbackBinder),
              TypeTab(markdownCallbackBinder: _markdownCallbackBinder),
            ],
          ),
        ),
      ),
    );
  }
}

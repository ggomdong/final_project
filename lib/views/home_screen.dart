import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/models/mood_model.dart';
import 'package:final_project/view_models/mood_view_model.dart';
import 'package:final_project/views/widgets/mood_card.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:final_project/utils.dart';
import 'package:final_project/views/widgets/common_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const routeUrl = "/home";
  static const routeName = "home";

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _searchText = '';
  List<MoodModel> _moods = [];

  void _onSearchChanged(String query) {
    setState(() {
      _searchText = query.toLowerCase();
    });
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(ref);
    final moodStream = ref.watch(moodProvider.notifier).watchMoods();

    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CommonAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.size32),
          child: Column(
            children: [
              // CupertinoSearchTextField(
              //   controller: _textEditingController,
              //   onChanged: _onSearchChanged,
              //   padding: EdgeInsets.all(Sizes.size9),
              //   backgroundColor:
              //       isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              //   style: TextStyle(
              //     color: isDark ? Colors.white : Colors.black,
              //   ),
              // ),
              Gaps.v10,
              Expanded(
                child: StreamBuilder<List<MoodModel>>(
                  stream: moodStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("기분 기록이 없네요. 처음으로 기분을 기록해볼까요?"),
                          ],
                        ),
                      );
                    }

                    _moods = snapshot.data!.toList();
                    return ListView.builder(
                      itemCount: _moods.length,
                      itemBuilder: (context, index) {
                        final mood = _moods[index];
                        final date =
                            DateFormat('yyyy-MM-dd (E) HH:mm', 'ko').format(
                          DateTime.fromMillisecondsSinceEpoch(mood.createdAt),
                        );

                        return MoodCard(
                          date: date,
                          mood: mood,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

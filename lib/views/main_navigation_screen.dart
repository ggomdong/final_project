import 'package:final_project/views/mood_calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/views/widgets/nav_tab.dart';
import 'package:final_project/views/home_screen.dart';
import 'package:final_project/views/post_screen.dart';
import 'package:final_project/utils.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const String routeName = "mainNavigation";
  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  final String tab;

  @override
  MainNavigationScreenState createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "post",
    "calendar",
  ];

  late int _selectedIndex =
      _tabs.contains(widget.tab) ? _tabs.indexOf(widget.tab) : 0;

  //최초 로딩시 라우팅을 적용함. url을 직접 쳤을때 대응을 위함
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentTab = GoRouterState.of(context).matchedLocation.split('/')[1];
    if (_tabs.contains(currentTab)) {
      _selectedIndex = _tabs.indexOf(currentTab);
    } else {
      _selectedIndex = 0;
    }
  }

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(ref);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: PostScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: MoodCalendarScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2C2C2C) : Color(0xFFECE6C2),
          border: Border(
            top: BorderSide(
              color: Colors.black,
              width: Sizes.size2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: Sizes.size12,
            right: Sizes.size12,
            top: Sizes.size24,
            bottom: Sizes.size52,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.house,
                selectedIcon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.pencil,
                selectedIcon: FontAwesomeIcons.pencil,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                isSelected: _selectedIndex == 2,
                icon: FontAwesomeIcons.calendar,
                selectedIcon: FontAwesomeIcons.calendar,
                onTap: () => _onTap(2),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

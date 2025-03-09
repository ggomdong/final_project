import 'package:final_project/constants/gaps.dart';
import 'package:final_project/constants/sizes.dart';
import 'package:final_project/repos/authentication_repo.dart';
import 'package:final_project/utils.dart';
import 'package:final_project/view_models/settings_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
  });

  void _onShowModal(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Please don't go"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              ref.read(authRepo).signOut();
              context.go("/");
            },
            isDestructiveAction: true,
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(ref);
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: ref.read(authRepo).isLoggedIn
          ? Row(
              children: [
                Gaps.h10,
                GestureDetector(
                  onTap: () => _onShowModal(context, ref),
                  child: FaIcon(
                    FontAwesomeIcons.arrowRightFromBracket,
                  ),
                ),
              ],
            )
          : null,
      title: Text(
        "🔥 MOOD 🔥",
        style: TextStyle(
          fontSize: Sizes.size20,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => ref.read(settingsProvider.notifier).setDarkMode(!isDark),
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
          ),
        ),
        Gaps.h10,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

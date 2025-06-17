import 'package:flutter/material.dart';
import 'package:traderwho/core/theme/app_color.dart';

class TraderWhoScaffold extends StatelessWidget {
  final Widget body;
  final bool isAppBar;
  final AppBar? appBarSecond;
  final PreferredSizeWidget? appBar; // Make appBar nullable
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const TraderWhoScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.isAppBar = false,
    this.drawer,
    this.appBarSecond,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAppBar ? appBarSecond : appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(color: AppColor.appBackground),
        child: body,
      ),
    );
  }
}

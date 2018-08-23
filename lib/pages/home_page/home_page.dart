import 'package:flutter/material.dart';

import 'package:simulop_v1/pages/home_page/home_tabs/uo_1_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_2_selection.dart';
import 'package:simulop_v1/pages/home_page/home_tabs/uo_3_selection.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar makeTabBar() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          icon: Icon(Icons.home),
          text: "Home",
        ),
        Tab(
          icon: Icon(Icons.settings),
          text: "Settings",
        ),
        Tab(
          icon: Icon(Icons.sentiment_very_satisfied),
          text: "Page 3",
        ),
      ],
      controller: tabController,
    );
  }

  TabBarView makeTabBarView(tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SimulOP v0.1"),
          bottom: makeTabBar(),
        ),
        body: makeTabBarView(<Widget>[
          OU1Selection(),
          OU2Selection(),
          OU3Selection(),
        ]));
  }
}

import 'package:flutter/material.dart';

import 'generate_history_view.dart';
import 'generate_more_view.dart';
import 'generate_phone_view.dart';
import 'generate_text_view.dart';
import 'generete_url_view.dart';

class QrGenerateScreen extends StatefulWidget {
  QrGenerateScreen({key}) : super(key: key);

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    print('deneme');
    tabController = TabController(vsync: this, initialIndex: 0, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: tabController,
        children: [
          GenerateTextView(),
          GenerateUrlView(),
          GeneratePhoneView(),
          GenerateMoreList(),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Generate',
      ),
      actions: [
        IconButton(
          tooltip: 'History',
          icon: Icon(
            Icons.history,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GenerateHistory()));
          },
        )
      ],
      bottom: buildTabBar(),
    );
  }

  PreferredSizeWidget buildTabBar() {
    return TabBar(
      labelColor: Colors.white,
      controller: tabController,
      indicatorColor: Color(0xff325CFD),
      tabs: [
        Tab(
          text: 'Text',
        ),
        Tab(
          text: 'Url',
        ),
        Tab(
          text: 'Phone',
        ),
        Tab(
          icon: Icon(Icons.menu),
        ),
      ],
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/db_helper.dart';
import '../../core/widget/button/standart_button.dart';
import '../../core/widget/card/standart_card.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../../core/extension/context_extension.dart';
import '../../models/generate_history_model.dart';
import 'generate_history.dart';
import 'generate_more_list.dart';
import 'generate_phone.dart';
import 'generete_url.dart';

class QrGenerateScreen extends StatefulWidget {
  QrGenerateScreen({key}) : super(key: key);

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List allHistory = <GenerateHistoryModel>[];
  Uint8List bytes = Uint8List(0);
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildBody(),
          QrGenerateUrl(),
          QrGeneratePhone(),
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GenerateHistory(allHistory)));
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

  Widget _buildInputTextFormField() {
    return TextFormField(
        controller: _inputController,
        maxLines: 1,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.text_fields,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            tooltip: 'Paste to ClipBoard',
            icon: Icon(
              Icons.paste,
              color: Colors.white,
            ),
            onPressed: () async {
              var data = await Clipboard.getData('text/plain');
              setState(() {
                _inputController.text = data!.text.toString();
              });
            },
          ),
          hintText: 'Please Input Your Text',
        ));
  }

  Widget _buildGenerateButton() {
    return StandartButton(
        title: 'GENERATE QR',
        onTap: () async {
          if (_inputController.text.isNotEmpty) {
            await _generateBarCode(_inputController.text);
          }
        });
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: context.paddingMedium,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StandartCard(byte: bytes),
          SizedBox(
            height: 16,
          ),
          _buildInputTextFormField(),
          SizedBox(
            height: 16,
          ),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Future _generateBarCode(String inputCode) async {
    var result = await scanner.generateBarCode(inputCode);
    setState(() {
      bytes = result;
      addDatabese();
    });
  }

  void addDatabese() async {
    await _databaseHelper
        .insert(GenerateHistoryModel('Text', _inputController.text, bytes));
    setState(() {
      getHistory();
    });
  }

  void getHistory() async {
    var historyFuture = _databaseHelper.getGenereteHistory();
    await historyFuture.then((data) {
      setState(() {
        allHistory = data;
      });
    });
  }
}

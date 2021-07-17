import 'package:flutter/material.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../core/init/service/local_database/db_helper.dart';
import '../../model/generate_history_model.dart';

class GenerateHistory extends StatefulWidget {
  @override
  _GenerateHistoryState createState() => _GenerateHistoryState();
}

class _GenerateHistoryState extends State<GenerateHistory> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<GenerateHistoryModel> allHistory = <GenerateHistoryModel>[];

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate History')),
      body: ListView.builder(
        itemCount: allHistory.length,
        itemBuilder: (context, index) {
          return _buildListViewCard(index);
        },
      ),
    );
  }

  Widget _buildListViewCard(int index) {
    return Card(
      color: Color(0xff325CFD),
      child: ListTile(
        onTap: () {},
        leading: Image.memory(allHistory[index].photo!),
        title: Text(
          allHistory[index].text!,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Row(
          children: [
            Text(
              allHistory[index].type!,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            _buildShareQrButton(index)
          ],
        ),
        trailing: _buildDeleteHistoryButton(index),
      ),
    );
  }

  Widget _buildShareQrButton(int index) {
    return IconButton(
        icon: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () async {
          if (allHistory[index].photo != null) {
            await WcFlutterShare.share(
                sharePopupTitle: 'share',
                fileName: 'share.png',
                mimeType: 'image/png',
                bytesOfFile: allHistory[index].photo);
          }
        });
  }

  Widget _buildDeleteHistoryButton(int index) {
    return IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () async {
          await _databaseHelper.delete(allHistory[index].id);

          getHistory();
        });
  }

  void getHistory() async {
    final getHistoryList = await _databaseHelper.getgeneretaHistory();
    setState(() {
      allHistory = getHistoryList;
    });
  }
}

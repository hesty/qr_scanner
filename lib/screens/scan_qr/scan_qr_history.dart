import 'package:flutter/material.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../utils/db_scan_history.dart';

// ignore: must_be_immutable
class ScanQrHistory extends StatefulWidget {
  List history;
  ScanQrHistory({history});

  @override
  _ScanQrHistoryState createState() => _ScanQrHistoryState();
}

class _ScanQrHistoryState extends State<ScanQrHistory> {
  final DbScanHistory _databaseHelper = DbScanHistory();

  void getHistory() async {
    var historyFuture = _databaseHelper.getScanHistory();

    await historyFuture.then((data) {
      setState(() {
        widget.history = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1D1F22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Scan Qr History',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
      ),
      body: widget.history == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xff325CFD),
                  child: ListTile(
                    onTap: () {},
                    leading: Image.memory(widget.history[index].photo),
                    title: Text(
                      widget.history[index].text,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (widget.history[index].photo != null) {
                                await WcFlutterShare.share(
                                    sharePopupTitle: 'share',
                                    fileName: 'share.png',
                                    mimeType: 'image/png',
                                    bytesOfFile: widget.history[index].photo);
                              }
                            })
                      ],
                    ),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await _databaseHelper
                              .deleteForScan(widget.history[index].id);
                          setState(() {
                            getHistory();
                          });
                        }),
                  ),
                );
              },
            ),
    );
  }
}

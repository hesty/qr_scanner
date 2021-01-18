import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/services/adver_service.dart';
import 'package:qr_scanner/utils/db_scan_history.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

// ignore: must_be_immutable
class ScanQrHistory extends StatefulWidget {
  List history;
  ScanQrHistory({history});

  @override
  _ScanQrHistoryState createState() => _ScanQrHistoryState();
}

class _ScanQrHistoryState extends State<ScanQrHistory> {
  final DbScanHistory _databaseHelper = DbScanHistory();

  final AdvertService _advertService = AdvertService();

  Future adsk() async {
    await Firebase.initializeApp();
    await FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-4694190778906605~9514991815', analyticsEnabled: true);
  }

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
    _advertService.disposeAllAdverTop();
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
        title: Text('Scan Qr History', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
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
                                    sharePopupTitle: 'share', fileName: 'share.png', mimeType: 'image/png', bytesOfFile: widget.history[index].photo);
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
                          await _databaseHelper.deleteForScan(widget.history[index].id);
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

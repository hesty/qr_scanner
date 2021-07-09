import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import '../../extension/context_extension.dart';

// ignore: must_be_immutable
class StandartCard extends StatefulWidget {
  Uint8List byte;
  StandartCard({Key? key, required this.byte}) : super(key: key);

  @override
  _StandartCardState createState() => _StandartCardState();
}

class _StandartCardState extends State<StandartCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        buildClipRRect(context),
        Padding(
          padding: context.paddingLow,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: context.height * 0.2,
                child: widget.byte.isEmpty
                    ? Center(
                        child: Text('Generate QR',
                            style: TextStyle(color: Colors.black38)),
                      )
                    : Image.memory(widget.byte),
              ),
              buildBodyRow()
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildClipRRect(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: context.height * .03,
        width: context.width,
        color: Color(0xff325CFD),
      ),
    );
  }

  Widget buildBodyRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () => setState(() => widget.byte = Uint8List(0)),
          child: Text(
            'Remove',
            style: TextStyle(fontSize: 15, color: Color(0xff325CFD)),
          ),
        ),
        Text('|', style: TextStyle(fontSize: 15, color: Colors.black26)),
        TextButton(
          onPressed: () async {
            await Permission.storage.request();
            try {
              var result = await ImageGallerySaver.saveImage(widget.byte);
              print(result);
              if (result['isSuccess']) {
              } else {}
            } catch (e) {
              throw Exception(e);
            }
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 15, color: Color(0xff325CFD)),
          ),
        ),
        _buildShareButton()
      ],
    );
  }

  Widget _buildShareButton() {
    return IconButton(
      icon: Icon(
        Icons.share,
      ),
      onPressed: () async {
        await WcFlutterShare.share(
            sharePopupTitle: 'share',
            fileName: 'share.png',
            mimeType: 'image/png',
            bytesOfFile: widget.byte);
      },
    );
  }
}

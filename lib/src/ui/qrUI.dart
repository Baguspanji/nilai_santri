import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nilai_santri/src/ui/detailUI.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrUIState();
}

class _QrUIState extends State<QrUI> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Container(
                margin: EdgeInsets.only(top: 400),
                child: InkWell(
                  onTap: () async {
                    await controller.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Icon(
                        snapshot.data
                            ? Icons.lightbulb
                            : Icons.lightbulb_outline,
                        color: Colors.white30,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.redAccent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 6,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailUI(id: scanData.code),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

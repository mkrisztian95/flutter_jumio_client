import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_jumio/flutter_jumio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _apiToken = 'c339d67a-fd3d-4114-b42a-4d211134928d';
  String _apiSecret = 'PIsBLmYKn8UiSvSNFUhMLYqXsSC6EiQf';

  bool _netverifyInitialized = false;
  bool _docVerificationInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  Future _initNetverify() async {
    await FlutterJumio.initNetverify(
      apiToken: _apiToken,
      apiSecret: _apiSecret,
      dataCenter: DataCenter.EU,
      config: NetverifyConfig(
        documentTypes: [
          DocumentType.PASSPORT, 
          DocumentType.DRIVER_LICENSE,
          DocumentType.IDENTITY_CARD,
          DocumentType.VISA,
        ],
        cameraPosition: CameraPosition.FRONT,
        dataExtractionOnMobileOnly: false,
        enableIdentityVerification: true,
        enableVerification: true,
        preselectedDocumentVariant: PreselectedDocumentVariant.PAPER,
        sendDebugInfoToJumio: true,
        enableWatchlistScreening: EnableWatchlistStreening.DEFAULT,
      )
    );
    setState(() {
      _netverifyInitialized = true;
    });
  }

  Future _startNetverify() async {
     await FlutterJumio.startNetVerify();
     setState(() {});
  }

  Future _initDocumentVerification() async {
    await FlutterJumio.initDocunmentVerification(
      apiSecret: _apiSecret,
      apiToken: _apiToken,
      dataCenter: DataCenter.EU,
      config: DocumentVerificationConfig(
        type: DocumentType.PASSPORT,
        country: Countries.Ukraine,
        userReference: 'Some User Reference',
        customerInternalReference: 'Some Customer Internal Reference',
      )
    );
    setState(() {
      _docVerificationInitialized = true;
    });
  }
  Future _startDocumentVerification() async {
    await FlutterJumio.startDocumentVerification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('JUMIO'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: _docVerificationInitialized ? Colors.grey : Colors.teal,
                    onPressed: _initDocumentVerification,
                    child: Text('Document - init'),
                  ),
                  RaisedButton(
                    onPressed: _docVerificationInitialized ? _startDocumentVerification : null,
                    child: Text('Document - flow'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: _netverifyInitialized ? Colors.grey : Colors.teal,
                    onPressed: _initNetverify,
                    child: Text('NetV - init'),
                  ),
                  RaisedButton(
                    onPressed: _netverifyInitialized ? _startNetverify : null,
                    child: Text('NetV - flow'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

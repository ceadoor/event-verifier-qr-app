import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String barcode = "";

  Future _scanQRCode() async{
  try{
    String barcode = await BarcodeScanner.scan();
    
    setState(() {
      this.barcode = barcode;
    });
  } on PlatformException catch (e){
    if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
  } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(child: Text("Hello"),
        onPressed: _scanQRCode,),
      ),
    );
  }
}
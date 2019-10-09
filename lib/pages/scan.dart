import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:trace/models/models.dart';
import 'package:http/http.dart' as http;

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String barcode = "";
  bool isLoading = false;
  Student student;

  Future _scanQRCode() async {
    try {
      setState(() {
        isLoading = true;
      });
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
      _validateStudent().then((student) {
        setState(() => this.student = student);
        setState(() {
          isLoading = false;
        });
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future _validateStudent() async {
    var data = {
      "uuid": barcode,
    };
    var body = json.encode(data);
    final response = await http.post(
        'https://hacktoberfest.abhijithvijayan.in/api/v1/getStudentDetails',
        body: body,
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200 || response.statusCode == 403) {
      return Student.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                (student == null)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Image.asset('assets/qr.png'),
                      )
                    : (student.status)?Padding(padding:EdgeInsets.only(top:100.0),child:Column(
                        children: <Widget>[
                          Text(student.message,style: TextStyle(fontSize: 26.0),),
                          Text(student.user["name"],style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold),),
                          ]
                          )):Padding(
                            padding: EdgeInsets.only(top: 100.0),
                            child:Text(student.message,style: TextStyle(fontSize: 26.0),)),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    child: Text("Scan"),
                    onPressed: _scanQRCode,
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() async{
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Savings'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String image = '';
  void getData() async{
    final response = await http.get(Uri.parse('https://fakeface.rest/face/json'));
    if (response.statusCode == 200) {
      Map body = json.decode(response.body);
      print(body);
      image = body['image_url'];
      print(image);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onQRViewCreated(QRViewController controller){
    setState(() => this.controller = controller);
  }

  Widget buildQRScanner(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      cutOutSize: MediaQuery.of(context).size.width*0.8,
      borderWidth: 10.0,
      borderLength: 20.0,
      borderRadius: 10.0,
      borderColor: Colors.green,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Icon(Icons.arrow_back_outlined),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Pay through UPI",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Enter Upi Number"
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    )
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                color: Colors.grey.shade500,
                height: MediaQuery.of(context).size.height,
              ),
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.5,
                        child: buildQRScanner(context),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search Contact",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: "Select Number"
                                    ),
                                  )
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.contacts),
                              )
                            ],
                          ),
                        ),
                        Card(
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage('$image'),
                                    )
                                ),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                children: [
                                  Text(
                                    "Sumanth Varma",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      "753000908"
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

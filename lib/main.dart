import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivenet/models/contact.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import './contact_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // hive init takes a string path and it is different depending on platform
  // path_provider resolves the document directory
  final appDocDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'hiveNet',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: FutureBuilder(
          future: Hive.openBox(
            'contacts',
            compactionStrategy: (int total, int deleted) {
              return deleted > 20;
            },
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Center(
                  child: Text(snapshot.error.toString(),
                      style: TextStyle(color: Theme.of(context).errorColor)),
                );
              else
                return ContactPage();
            } else
              return Scaffold();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box('contacts').compact();
    Hive.close();
    super.dispose();
  }
}

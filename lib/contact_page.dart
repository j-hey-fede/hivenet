import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './new_contact_form.dart';
import 'models/contact.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "hiveNet",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(child: _buildListView()),
              NewContactForm(),
            ],
          ),
        ));
  }

  Widget _buildListView() {
    return WatchBoxBuilder(
        box: Hive.box('contacts'),
        builder: (context, contactsBox) {
          return ListView.builder(
              itemCount: contactsBox.length,
              itemBuilder: (context, i) {
                final contact = contactsBox.getAt(i) as Contact;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink,
                    child: Text(
                      contact.name[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.age.toString()),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            contactsBox.putAt(
                                i,
                                Contact(
                                    name: '${contact.name}*',
                                    age: (contact.age + 1)));
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            contactsBox.deleteAt(
                              i,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

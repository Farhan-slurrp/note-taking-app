import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MakeNote extends StatefulWidget {
  MakeNote({Key? key}) : super(key: key);

  @override
  _MakeNoteState createState() => _MakeNoteState();
}

class _MakeNoteState extends State<MakeNote> {
  static String _title = "";
  static String _content = "";
  FToast ftoast = FToast();

  @override
  void initState() {
    super.initState();
    ftoast.init(context);
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Note added"),
        ],
      ),
    );

    ftoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void _setTitle(String value) {
    setState(() {
      _title = value;
    });
  }

  void _setContent(String value) {
    setState(() {
      _content = value;
    });
  }

  _createNote() async {
    if (_title != "" && _content != "") {
      await http.post(
        Uri.parse('https://boiling-sands-85947.herokuapp.com/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{'title': _title, 'content': _content}),
      );
    }
    _showToast();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Make New Note ✏",
                  style: GoogleFonts.montserrat(
                      textStyle:
                          TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(19, 50, 19, 15),
                child: TextField(
                  obscureText: false,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54)),
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      labelStyle:
                          TextStyle(color: Colors.black54, fontSize: 18),
                      hintStyle: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500))),
                  onChanged: _setTitle,
                ),
              ),
              Container(
                margin: EdgeInsets.all(19),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black45)),
                child: TextFormField(
                  autocorrect: true,
                  maxLines: 12,
                  maxLength: 1000,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      hintText: "Your note here...",
                      hintStyle:
                          TextStyle(color: Colors.black38, fontSize: 19)),
                  onChanged: _setContent,
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 19, right: 19, top: 35),
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "CREATE",
                  style: GoogleFonts.montserrat(
                      textStyle:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                ),
              ),
              onPressed: _createNote,
            ))
      ],
    );
  }
}

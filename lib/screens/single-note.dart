import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mynotes/screens/update-note.dart';

class Note {
  int _id;
  String _name;
  String _createdAt;
  String _content;

  Note(this._id, this._name, this._createdAt, this._content);
}

class SingleNote extends StatefulWidget {
  final int _id;

  SingleNote(this._id);

  @override
  _SingleNoteState createState() => _SingleNoteState();
}

class _SingleNoteState extends State<SingleNote> {
  Future<Note> _getNote() async {
    var url = Uri.parse(
        "https://boiling-sands-85947.herokuapp.com/" + widget._id.toString());
    var response = await http.get(url);
    var data = jsonDecode(response.body);

    Note note =
        new Note(data["ID"], data["title"], data["CreatedAt"], data["content"]);

    return note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Note 📝",
            style: GoogleFonts.montserrat(
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500, fontSize: 22)),
          ),
        ),
        body: FutureBuilder(
          future: _getNote(),
          builder: (context, AsyncSnapshot<Note> snapshot) {
            if (snapshot.data == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                      child: Text(
                    "Loading..",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(fontSize: 20)),
                  )),
                ],
              );
            } else {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 18, right: 18),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateNote(
                                          snapshot.data!._id,
                                          snapshot.data!._name,
                                          snapshot.data!._content)))
                              .then((_) => setState(() {})),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Edit",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        fontSize: 18, color: Colors.blue[800])),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.blue[800],
                              )
                            ],
                          ),
                        )),
                    SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
                      child: Text(
                        snapshot.data!._name,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 3, 18, 20),
                      child: Text(
                        DateFormat.yMMMMEEEEd()
                            .format(DateTime.parse(snapshot.data!._createdAt)),
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 30, 18, 20),
                      child: Text(
                        snapshot.data!._content,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}

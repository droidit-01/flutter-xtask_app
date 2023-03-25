import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xstask/Screens/Note_Detail/Controllers/NoteDetail.dart';
import 'package:xstask/models/note.dart';
import 'package:xstask/Screens/Edit_Note/edit_note_page.dart';

import '../../db/notes_database.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final controller = Get.put(NotedetailController());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [editButton(), deleteButton()],
        ),
        body: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      controller.note.title,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(controller.note.createdTime),
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white38 : Colors.black38,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.note.description,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(
        Icons.edit_outlined,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () async {
        if (controller.isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: controller.note),
        ));

        controller.refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(
          Icons.delete,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);

          Navigator.of(context).pop();
        },
      );
}

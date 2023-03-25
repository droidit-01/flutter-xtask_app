import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:xstask/Screens/Notes/Controllers/NoteController.dart';
import 'package:xstask/db/notes_database.dart';
import 'package:xstask/models/note.dart';
import 'package:xstask/Screens/Edit_Note/edit_note_page.dart';
import 'package:xstask/Screens/Note_Detail/note_detail.page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xstask/services/theme.dart';

import '../../widgets/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final controller = Get.put(NoteController());
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          title: Text(
            'Notes',
            style: TextStyle(
              fontSize: 24,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              )),
          actions: [
            Icon(
              Icons.search,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            SizedBox(width: 12),
          ],
        ),
        body: Center(
          child: controller.isLoading
              ? CircularProgressIndicator()
              : controller.notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 24),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: bluishclr,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            Get.to(() => AddEditNotePage());

            controller.refreshNotes();
          },
        ),
      );

  buildNotes() => Container(
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        child: MasonryGridView.count(
          itemCount: controller.notes.length,
          crossAxisCount: 2,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          itemBuilder: (context, index) {
            final note = controller.notes[index];
            return GestureDetector(
              onTap: () async {
                Get.to(() => NoteDetailPage(noteId: note.id!));

                controller.refreshNotes();
              },
              child: NoteCardWidget(
                note: note,
                index: index,
              ),
            );
          },
        ),
      );
}

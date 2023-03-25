import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:xstask/db/notes_database.dart';
import 'package:xstask/models/note.dart';

class NotedetailController extends GetxController {
  late Note note = Note(
      isImportant: true,
      number: 0,
      title: '',
      description: '',
      createdTime: DateTime.now());

  bool isLoading = false;

  @override
  void initState() {
    refreshNote();
  }

  Future refreshNote() async {
    var widget;
    isLoading = true;

    this.note = await NotesDatabase.instance.readNote(widget.noteId!);

    isLoading = false;
  }
}

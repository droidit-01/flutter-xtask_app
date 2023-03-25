import 'package:get/get.dart';
import 'package:xstask/db/notes_database.dart';
import 'package:xstask/models/note.dart';

class NoteController extends GetxController {
  late List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    refreshNotes();
  }

  @override
  void dispose() {
    // NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    isLoading = true;

    this.notes = await NotesDatabase.instance.readAllNotes();

    isLoading = false;
  }
}

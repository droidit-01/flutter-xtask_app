import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:xstask/Screens/Edit_Note/Controllers/EditNoteController.dart';
import 'package:xstask/db/notes_database.dart';
import 'package:xstask/models/note.dart';
import 'package:xstask/services/theme.dart';
import 'package:xstask/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final controller = Get.put(EditnoteController());
  late Note note;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.backgroundColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              )),
          actions: [buildButton()],
        ),
        body: Form(
          key: controller.formKey,
          child: NoteFormWidget(
            isImportant: controller.isImportant,
            number: controller.number,
            title: controller.title,
            description: controller.description,
            onChangedImportant: (isImportant) =>
                setState(() => this.controller.isImportant = isImportant),
            onChangedNumber: (number) =>
                setState(() => this.controller.number = number),
            onChangedTitle: (title) =>
                setState(() => this.controller.title = title),
            onChangedDescription: (description) =>
                setState(() => this.controller.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid =
        controller.title.isNotEmpty && controller.description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? bluishclr : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = controller.formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: controller.isImportant,
      number: controller.number,
      title: controller.title,
      description: controller.description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: controller.title,
      isImportant: true,
      number: controller.number,
      description: controller.description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}

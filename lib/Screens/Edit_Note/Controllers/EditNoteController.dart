import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditnoteController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late bool isImportant = false;
  late int number = 0;
  late String title = '';
  late String description = '';

  @override
  void initState() {
    var widget;

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }
}

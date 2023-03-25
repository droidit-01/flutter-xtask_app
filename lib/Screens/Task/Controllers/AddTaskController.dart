import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskController extends GetxController {
  static AddTaskController get instance => Get.find();

  final title = TextEditingController();
  final note = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String endTime = "9:30 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int selectedColor = 0;

  static var controller;
}

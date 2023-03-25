import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xstask/Screens/Task/Controllers/AddTaskController.dart';
import 'package:xstask/controllers/task_controller.dart';
import 'package:xstask/services/notification_service.dart';
import 'package:xstask/services/theme.dart';
import 'package:xstask/widgets/button.dart';
import 'package:xstask/widgets/input_field.dart';

import '../../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskController = Get.put(TaskController());
  final controller = Get.put(AddTaskController());

  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                  title: "Title",
                  hint: "Enter  Your Title",
                  controller: controller.title),
              MyInputField(
                  title: "Note",
                  hint: "Enter  Your Title",
                  controller: controller.note),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(controller.selectedDate),
                widget: IconButton(
                  onPressed: () {
                    print("hey there");

                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: controller.startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: controller.endTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "${controller.selectedRemind} minutes early",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  items: controller.remindList
                      .map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      controller.selectedRemind = int.parse(newValue!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: "${controller.selectedRepeat}",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  items: controller.repeatList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      controller.selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateDate()),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (controller.title.text.isNotEmpty && controller.note.text.isNotEmpty) {
      //add Database
      _addTaskToDb();
      Get.back();
    } else if (controller.title.text.isEmpty || controller.note.text.isEmpty) {
      Get.snackbar(
        '',
        '',
        titleText: const Text(
          "Required",
          style: TextStyle(color: Colors.red),
        ),
        messageText: Text(
          "All fields are required !",
          style: TextStyle(color: Colors.red),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addTaskToDb() async {
    var value = await _taskController.addTask(
      task: Task(
        note: controller.title.text,
        title: controller.note.text,
        date: DateFormat.yMd().format(controller.selectedDate),
        startTime: controller.startTime,
        endTime: controller.endTime,
        remind: controller.selectedRemind,
        repeat: controller.selectedRepeat,
        color: controller.selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    controller.selectedColor = index;
                    print("$index");
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryclr
                        : index == 1
                            ? pinkclr
                            : yellowclr,
                    child: controller.selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage('images/jay.jpeg'),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2121),
    );
    if (_pickerDate != null) {
      setState(() {
        controller.selectedDate = _pickerDate;
        print(controller.selectedDate);
      });
    } else {
      print("it's null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time canceld");
    } else if (isStartTime == true) {
      setState(() {
        controller.startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        controller.endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(controller.startTime.split(":")[0]),
        minute: int.parse(controller.startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}

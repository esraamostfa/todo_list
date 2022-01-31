import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_list/shared/components/components.dart';
import 'package:todo_list/shared/constants/constants.dart';
import 'package:todo_list/shared/cubit/app_cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {

          AppCubit appCubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                appCubit.titles[appCubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (appCubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    appCubit.insertIntoDb(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text)
                        .then((value){
                        Navigator.pop(context);
                    });

                  }
                } else {
                  scaffoldKey.currentState.showBottomSheet((context) => Container(
                    color: Colors.grey[201],
                    margin: EdgeInsets.all(25),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextForm(
                              controller: titleController,
                              textInputType: TextInputType.text,
                              label: 'Task Title',
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Title can\'t be empty';
                                }
                                return null;
                              },
                              prefixIcon: Icons.title),
                          SizedBox(
                            height: 15,
                          ),
                          defaultTextForm(
                            controller: timeController,
                            textInputType: TextInputType.datetime,
                            onTape: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                                  .then((value) {
                                   timeController.text = value.format(context);
                              });
                            },
                            label: 'Task Time',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Task time can\'t be empty';
                              }
                              return null;
                            },
                            prefixIcon: Icons.watch_later_outlined,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          defaultTextForm(
                            controller: dateController,
                            textInputType: TextInputType.datetime,
                            onTape: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2021-07-31'))
                                  .then((value) {
                                   dateController.text = DateFormat.yMMMd().format(value);
                              });
                            },
                            label: 'Task Date',
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Task date can\'t be empty';
                              }
                              return null;
                            },
                            prefixIcon: Icons.watch_later_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                    elevation: 21,
                  ).closed.then((value) {
                    appCubit.changeBottomSheetState();
                  });
                  appCubit.changeBottomSheetState();
                }
              },
              child: appCubit.isBottomSheetShown ? Icon(Icons.add) : Icon(Icons.edit),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => appCubit.screens[appCubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                appCubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
      },
      ),
    );
  }

}

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/shared/components/components.dart';
import 'package:todo_list/shared/cubit/app_cubit.dart';
import 'package:todo_list/shared/cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
        },
        builder: (context, state) {

          var tasks = AppCubit.get(context).archiveTasks;
          return ConditionalBuilder(condition: tasks.length > 0,
              builder: (context) => ListView.separated(
                  itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: Colors.grey[300],
                    margin: EdgeInsets.all(21),
                  ),
                  itemCount: tasks.length),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu),
                  Text('No Archive Tasks!')
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNaveBottomBarState());
  }

  bool isBottomSheetShown = false;

  void changeBottomSheetState () {
    isBottomSheetShown = !isBottomSheetShown;
    emit(AppChangeBottomSheetState());
  }


  Database todoDB;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDB() {
    openDatabase(
      'todoDb.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error during creating table: ${error.toString}');
        });
      },
      onOpen: (database) {
        getFromDb(database);
      },
    ).then((value) {
      todoDB = value;
      emit(AppCreateDbState());
    });
  }

  Future insertIntoDb(
      {@required String title,
      @required String time,
      @required String date}) async {
    todoDB.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted');
        emit(AppInsertIntoDbState());
        getFromDb(todoDB);
      }).catchError((error) {
        print('error during insert data: ${error.toString()}');
      });

      return null;
    });
  }

  void updateData({
    @required String status, @required int id}) async {
    await todoDB.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getFromDb(todoDB);
          emit(AppUpdateDbState());

    });
  }

  void deleteDate ({@required int id}) {
    todoDB
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
          getFromDb(todoDB);
          emit(AppDeleteDbState());
    });
  }

  void getFromDb(database)  {

    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    database.rawQuery('SELECT * FROM tasks').then((value){

      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        }else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetFromDbState());
    });
  }
}

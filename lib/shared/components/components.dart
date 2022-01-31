import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/cubit/app_cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.lightBlue,
  Color textColor = Colors.white,
  bool isUpperCase = true,
  @required String text,
  @required Function function,
}) =>
    Container(
        width: width,
        child: MaterialButton(
          color: background,
          child: Text(isUpperCase ? text.toUpperCase() : text),
          textColor: textColor,
          onPressed: function,
        ));

Widget defaultTextForm({
  @required controller,
  @required TextInputType textInputType,
  Function onSubmit,
  Function onChange,
  @required String label,
  @required Function validator,
  @required IconData prefixIcon,
  IconData suffixIcon,
  bool isPassword = false,
  Function onTape,
  bool isEnabled = true,

}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      validator: validator,
      onTap: onTape,
      enabled: isEnabled,
      obscureText: isPassword,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          border: OutlineInputBorder()),
    );

Widget buildTaskItem(Map model, context) => GestureDetector(
  onPanEnd: (d) {
    AppCubit.get(context).deleteDate(id: model['id']);
  },
  child:   Row(
    children: [
      CircleAvatar(
        radius: 41,
        child: Text(model['time']),
      ),
      SizedBox(width: 15,),
      Expanded(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(model['title'],
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(model['date'],
                style: TextStyle(color:  Colors.grey),
              ),
            ]
        ),
      ),
      SizedBox(width: 25,),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(status: 'done', id: model['id']);
      },
          icon: Icon(Icons.check_box, color:  Colors.green,)),
      SizedBox(width: 15,),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(status: 'archive', id: model['id']);
      },
          icon: Icon(Icons.archive_outlined, color: Colors.black45,)),
  
    ],),
);

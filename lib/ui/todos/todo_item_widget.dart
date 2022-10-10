/*
 * Copyright (c) 2021 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for
 * pedagogical or instructional purposes related to programming, coding,
 * application development, or information technology.  Permission for such
 * use, copying, modification, merger, publication, distribution, sublicensing,
 * creation of derivative works, or sale is expressly withheld.
 *
 * This project and source code may use libraries or frameworks that are
 * released under various Open-Source licenses. Use of those libraries and
 * frameworks are governed by their own individual licenses.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'package:flutter/material.dart';

import '../../data/repository/todos_repository.dart';
import '../../models/todo_model.dart';
import '../../utils/datetime_utils.dart';
import '../app_colors.dart';
import 'add_todo_widget.dart';

class TodoItemWidget extends StatefulWidget {
  final TodoModel todo;
  final TodosRepository todosRepository;
  final Function moveTop;

  const TodoItemWidget({
    Key? key,
    required this.todo,
    required this.todosRepository,
    required this.moveTop,
  }) : super(key: key);

  @override
  _TodoItemWidgetState createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  late TodoModel todoModel;

  TodoModel get todo => todoModel;

  set todo(TodoModel todoModel) {
    this.todoModel = todoModel;
  }

  late bool isDone;
  bool isDeleted = false;

  @override
  void initState() {
    todo = widget.todo;
    isDone = todo.isDone;
    super.initState();
  }

  Future<void> setTodoToDone() async {
    try {
      final isSavedSuccessfully =
          await widget.todosRepository.editTodo(todo.copyWith(isDone: true));
      if (isSavedSuccessfully && mounted) {
        setState(() {
          isDone = true;
        });
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while setting the todo to done!'),
        ),
      );
    }
  }

  Future<void> deleteTodo() async {
    try {
      final isDeletedSuccessfully =
          await widget.todosRepository.deleteTodo(todo);
      if (isDeletedSuccessfully && mounted) {
        setState(() {
          isDeleted = true;
        });
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while deleting the todo!'),
        ),
      );
    }
  }

  void setDoneOrDelete() {
    if (!isDone) {
      setTodoToDone();
    } else if (!isDeleted) {
      deleteTodo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final itemColor = colorScheme.primary.withOpacity(0.05 * todo.priority);
    final priorityIconColor =
        colorScheme.secondaryVariant.withOpacity(0.2 * todo.priority);

    return isDeleted
        ? const SizedBox.shrink()
        : buildListTile(itemColor, textTheme, priorityIconColor, context);
  }

  Column buildListTile(Color itemColor, TextTheme textTheme,
      Color priorityIconColor, BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            showMyForm(context);
          },
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            tileColor: itemColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            title: Text(
              todo.text,
              style: textTheme.subtitle1!.copyWith(
                  decoration: isDone ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(
              DateTimeUtils.formattedDate(todo.dueDate),
              style: textTheme.bodyText2!.copyWith(
                  color: AppColors.accentColor,
                  height: 2,
                  decoration: isDone ? TextDecoration.lineThrough : null),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  onPressed: () => setDoneOrDelete(),
                  icon: Icon(isDone ? Icons.close_sharp : Icons.check_sharp),
                  iconSize: 25,
                ),
                IconButton(
                    icon: Icon(Icons.arrow_upward_rounded,
                        size: 25, color: priorityIconColor),
                    onPressed: () {
                      widget.moveTop();
                    }),
                PopupMenuButton(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.2,
                    maxWidth: MediaQuery.of(context).size.width * 0.33,
                  ),
                  offset: const Offset(-10, 0),
                  child: const Icon(
                    Icons.menu,
                    size: 25,
                  ),
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.settings,
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: Text('Edit'),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            showMyForm(context);
                          }),
                      PopupMenuItem(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.remove_circle,
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                child: Text('Remove'),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          deleteTodo();
                        },
                      )
                    ];
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showMyForm(BuildContext context) {
    print('onto');
    WidgetsBinding?.instance?.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return const AlertDialog(
          //   title: Text('ads'),
          //   content: Text('assayed'),
          // );
          // return Scaffold(
          //     body: AddTodoWidget(
          //         onSubmitTap: addTodo, todo: todo));
          return Dialog(
              child: AddTodoWidget(
                  onSubmitTap: editTodo,
                  widgetTodo: todoModel));
        },
      );
    });
  }

  Future<void> editTodo(TodoModel todoLocal) async {
    try {
      final isAdded = await widget.todosRepository.editTodo(todoLocal);
      if (isAdded && mounted) {
        setState(() {
          todoModel = todoLocal;
        });
      }
      Navigator.pop(context);
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while adding the todo!'),
        ),
      );
    }
  }
}

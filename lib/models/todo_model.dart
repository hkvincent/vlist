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

@immutable
class TodoModel {
  const TodoModel({
    this.tid = '',
    this.text = '',
    required this.dueDate,
    this.priority = 3,
    this.isDone = false,
  });

  final String? tid;
  final String text;
  final DateTime dueDate;
  final int priority;
  final bool isDone;

  TodoModel.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        dueDate = DateTime.parse(json['dueDate']),
        priority = int.parse(json['priority']),
        isDone = json['isDone'].toLowerCase() == true.toString().toLowerCase(),
        tid = json['tid'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'dueDate': dueDate.toIso8601String(),
        'priority': priority.toString(),
        'isDone': isDone.toString(),
        'tid': tid,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel &&
          runtimeType == other.runtimeType &&
          tid == other.tid;

  @override
  int get hashCode =>
      {text + dueDate.toIso8601String() + priority.toString()}.hashCode;

  TodoModel copyWith({
    String? tid,
    String? text,
    DateTime? dueDate,
    int? priority,
    bool? isDone,
  }) {
    return TodoModel(
      text: text ?? this.text,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      tid: tid ?? this.tid,
    );
  }
}

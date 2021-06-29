// Copyright 2021, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

@immutable
class Note {
  final String note;
  final int happyRate;
  final bool isDeleted;
  final DateTime dateTime;

  Note({
    required this.note,
    required this.happyRate,
    required this.isDeleted,
    required this.dateTime,
  });

  Note.fromJson(Map<String, Object?> json)
      : this(
          happyRate: json['happyRate']! as int,
          note: json['note']! as String,
          isDeleted: json['isDeleted']! as bool,
          dateTime: json['dateTime']! as DateTime,
        );

  Map<String, Object?> toJson() {
    return {
      'happyRate': happyRate,
      'note': note,
      'isDeleted': isDeleted,
      'dateTime': dateTime,
    };
  }
}

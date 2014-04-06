#!/usr/bin/env dart
library hop_runner;

import 'dart:io';
import 'package:args/args.dart';
import 'package:hop/hop.dart';
import 'package:hop_docgen/hop_docgen.dart';
import 'package:hop/hop_tasks.dart';

const List<String> PATHS = const <String>[
];

final String BASH_PROFILE_PATH = '${Platform.environment['HOME']}/.bash_profile';

void main (List<String> args) {
  addTask('install', (TaskContext ctx) {
    //adding path
    switch (FileSystemEntity.typeSync(BASH_PROFILE_PATH, followLinks: false)) {
      case FileSystemEntityType.FILE:
        File file = new File(BASH_PROFILE_PATH);
        String content = file.readAsStringSync();
        String dir = '${Directory.current.absolute.path.toString()}/tool';
        if (!content.contains(dir)) {
          content = '$content\nexport PATH=\$PATH:$dir\n';
        }
        file.writeAsStringSync(content, mode: FileMode.WRITE);
        break;
      default:
        print('Invalid bash_profile');
    }
  }, description: 'Installs');
  runHop(args);
}
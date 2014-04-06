import 'dart:async';
import 'dart:io';

void main () {
  File f = new File('../LICENSE');
  f.readAsString().then((content) {
    StringBuffer buf = new StringBuffer();
    content.split('\n').forEach((line) {
      line = line.trim();
      if (line.length < 80) {
        buf.write('$line\n');
      } else {
        do {
          String tmp = line.substring(0, 80);
          int end = tmp.lastIndexOf(' ');
          tmp = line.substring(0, end);
          buf.write('$tmp\n');
          line = line.substring(end).trim();
        } while(line.length > 80);
        buf.write('$line\n');
      }
    });
    f.writeAsStringSync(buf.toString(), mode: FileMode.WRITE);
  });
}
/**
 * Copyright (C) 2014  Andrea Cantafio kk4r.1m@gmail.com
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
part of jschema;

typedef bool KeyValidator(value);

class Key<T> {
  
  final T defaultValue;
  final String name;
  final KeyValidator validate;
  
  Key._(this.name, this.defaultValue, this.validate);
  
  static final Key<bool> CASE_SENSITIVE = new Key._('caseSensitive', true, utils.isBool);
  
  static final Key<bool> DEFAULT_VALUE = new Key._('defaultValue', null, (_) => true);
  
  static final Key<Map> FIELDS = new Key._('fields', {},
      (value) => value is Map<String, Field>);
  
  static final Key<String> FORMAT = new Key._('format', [], 
      (value) => value is String || value is List<String>);
  
  static final Key<String> FORMAT_DECLARATION = new Key._('format', {}, 
      (value) => value is Map<String, dynamic>);
  
  static final Key<Map<String, Format>> FORMATS = new Key._('formats', {}, 
      (value) => value is Map<String, Format>);
  
  static final Key<num> MATCH = new Key._('match', null, utils.isString);
  
  static final Key<int> MAX_INT = new Key._('max', null, utils.isInt);
  
  static final Key<num> MAX_NUM = new Key._('max', null, utils.isNum);
  
  static final Key<int> MIN_INT= new Key._('min', null, utils.isInt);
  
  static final Key<num> MIN_NUM = new Key._('min', null, utils.isNum);
  
  static final Key<bool> MULTI_LINE = new Key._('multiLine', false, utils.isBool);
  
  static final Key<String> NAME = new Key._('name', null, utils.isString);
  
  static final Key REQUIRED = new Key._('required', true, utils.isBool);
  
  static final Key TYPE_FORMAT = new Key._('type', 'string', utils.isString);
  
  static final Key TYPE_SCHEMA = new Key._('type', 'object', utils.isString);
  
  static final Key TYPE_TYPE = new Key._('type', 'object', utils.isString);
  
  static final Key TYPES = new Key._('types', const {},
      (value) => value is Map<String, Type>);
}
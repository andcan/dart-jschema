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

/**
 * Every field allows keys:
 * *[defaultValue] [Object] - Default Value for this field.
 * *[format] [List<String>] - Applied format's name.
 * *[max] [int] - max value for this [Field].
 * *[min] [int] - min value for this [Field].
 * *[required] [bool] - if [:true:] validation fails when field is missing.
 * *[type] [String] - Type of this [Field].
 */
class Field extends Object {
  /**
   * Default value of this [Field].
   */
  final defaultValue;
  /**
   * [Format] of this [Field].
   */
  final List<Format> format;
  /**
   * Max value for this field.
   */
  final int max;
  /**
   * Min value for this field.
   */
  final int min;
  /**
   * [:true:] if this [Field] is required.
   */
  final bool required;
  /**
   * Type of this [Field].
   */
  final String type;
  
  Field (dynamic this.defaultValue, List<Format> this.format, num this.max, 
      num this.min, bool this.required, String this.type);
  
  int get hashCode {
    return utils.hashCode([format, max, min, required]);
  }
  
  String toString () =>
      '{\n\tformat: $format,\n\tmax: $max,\n\tmin: $min,\n\trequired: $required\n}';
  
  operator == (Field f) => 
      (format.isNotEmpty
          && format.length == f.format.length 
          && format.every((fmt) => f.format.contains(fmt))) 
        || (format.isEmpty && f.format.isEmpty)
      && max == f.max && min == f.min && required == f.required;
}
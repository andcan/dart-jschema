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
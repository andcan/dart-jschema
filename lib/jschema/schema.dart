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

class Schema {
  /**
   * [Map] containing fields
   */
  final Map<String, Field> fields;
  /**
   * name of this [Schema]
   */
  final String name;
  /**
   * [Map] containing formats
   */
  final Map<String, Format> formats;
  /**
   * type of this [Schema]
   */
  final String type;
  /**
   * [Map] containing types
   */
  final Map<String, JSchemaType> types;
  
  Schema (this.fields, this.name, this.formats, this.type, this.types);
  
  factory Schema.fromMap (Map schema) {
    var fmts;
    if (!schema.containsKey(Key.FORMATS.name)) {
      fmts = Key.FORMATS.defaultValue;
    } else {
      fmts = schema[Key.FORMATS.name];
    }
    Map<String, Format> formats = parseFormats(fmts);
    
    var fs;
    if (!schema.containsKey(Key.FIELDS.name)) {
      fs = Key.FIELDS.defaultValue;
    } else {
      fs = schema[Key.FIELDS.name];
    }
    Map<String, Field> fields = parseFields(fs, formats);
    
    var name;
    if (!schema.containsKey(Key.NAME.name)) {
      name = Key.NAME.defaultValue;
    } else {
      name = schema[Key.NAME.name];
    }
    
    var type;
    if (!schema.containsKey(Key.TYPE_SCHEMA.name)) {
      type = Key.TYPE_SCHEMA.defaultValue;
    } else {
      type = schema[Key.TYPE_SCHEMA.name];
    }
    
    var ts;
    if (!schema.containsKey(Key.TYPES.name)) {
      ts = Key.TYPES.defaultValue;
    } else {
      ts = schema[Key.TYPES.name];
    }
    Map<String, JSchemaType> types = parseTypes(ts, formats);
    return new Schema(fields, name, formats, type, types);
  }
  
  bool validate (Map json) {
    var names = fields.keys;
    for (String name in names) {
      var field = fields[name];
      
      if (! json.containsKey(name)) {
        if (null != field.defaultValue) {
          json[name] = field.defaultValue;
        } else {
          if (field.required) {
            return false;
          }
        }
      } else {
        var optional = _validate(json[name], field);
        if (optional.isAbsent) {
          return false;
        }
        json[name] = optional.value;
      }
    }
    return true;
  }
  
  utils.Optional _validate (value, Field field) {
    int max = field.max;
    int min = field.min;
    String type = field.type;
    
    if (null == value) {
      if (null != field.defaultValue) {
        return new utils.Optional(field.defaultValue);
      } else {
        if (field.required) {
          return new utils.Optional.absent();
        }
        return new utils.Optional(null);
      }
    }
    
    bool valid = true;
    var conversionError = (value) {
      valid = false;
      return -1;
    };
    
    switch (type) {
      case 'bool':
        valid = value is bool;
        break;
      case 'int':
        if (value is! int) {
          if (value is! String) {
            valid = false;
          } else {
            value = int.parse(value, onError: conversionError);
          }
        }
        if (valid) {
          if (null != max) {
            valid = value <= max;
          }
          if (null != min) {
            valid = valid && value >= min;
          }
        }
        break;
      case 'num':
        if (value is! num) {
          if (value is! String) {
            valid = false;
          } else {
            value = double.parse(value, conversionError);
            if (null != max) {
              valid = value <= max;
            }
            if (null != min) {
              valid = valid && value >= min;
            }
          }
        }
        if (valid) {
          if (null != max) {
            valid = value <= max;
          }
          if (null != min) {
            valid = value >= min;
          }
        }
        break;
      case 'string':
        if (value is! String) {
          valid = false;
        } else {
          if (null != max) {
            valid = value.length <= max;
          }
          if (null != min) {
            valid = valid && value.length >= min;
          }
          List<Format> format = field.format;
          if (format.length > 0) {
            valid = valid && field.format.any((format) => format.match.hasMatch(value));
          }
        }
        break;
      case 'object':
        if (value is! Map) {
          valid = false;
        }
        break;
      default:
        if (LIST.hasMatch(type)) {
          Match m = LIST.firstMatch(type);
          if (value is! List) {
            valid = false;
          } else {
            for (int i = 0; i < value.length; i++) {
              var optional = _validate(value[i], new Field(field.defaultValue, field.format, field.max, field.min, field.required, m[1]));
              if (optional.isAbsent) {
                valid = false;
                break;
              }
              value[i] = optional.value;
            }
          }
        } else {
          if (! types.containsKey(type)) {
            valid = false;
          } else {
            var optional = _validateObject(value, types[type], type);
            if (optional.isAbsent) {
              valid = false;
            }
            value = optional.value;
          }
        }
        break;
    }
    return valid ? new utils.Optional(value) : new utils.Optional.absent();
  }
  
  utils.Optional _validateObject (Map map, JSchemaType type, [String typeName = null]) {
    var fields = type.fields;
    var names = fields.keys;
    for (String name in names) {
      Field field = fields[name];
      var value = map[name];
      
      if (! map.containsKey(name)) {
        if (field.required) {
          if (null == field.defaultValue) {
            return new utils.Optional.absent();
          } else {
            map[name] = field.defaultValue;
          }
        } else {
          map[name] = field.defaultValue;
        }
      } else {
        var optional = _validate(map[name], field);
        if (optional.isAbsent) {
          return optional;
        }
        map[name] = optional.value;
      }
    }
    utils.Optional value;
    if (null != typeName) {
      var instance;
      try {
        instance = utils_mirrors.newInstance(utils_mirrors.symbol(typeName), new Map.fromIterables(map.keys.map((f) => utils_mirrors.symbol(f)), map.values)).reflectee;
      } on ArgumentError catch (e) {
        instance = map;//Error while creating object. Falling back to map representation
      }
      if (null != instance) {
        value = new utils.Optional (instance is InstanceMirror ? 
            instance.reflectee : instance);
      } else {
        value = new utils.Optional(map);
      }
    } else {
      value = new utils.Optional(map);
    }
    return value;
  }
  
  static final RegExp LIST = new RegExp(r'\b(\w+)\b\[\]', multiLine: false, caseSensitive: true);
}
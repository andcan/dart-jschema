part of jschema;

const String PARAM_KEY_NAME = r'${key_name}';
const String PARAM_MAP = r'${map}';
const String PARAM_TYPE_EXPECTED = r'${expected_type}';
const String PARAM_TYPE_WRONG = r'${wrong_type}';
const String PARAM_VAR_NAME = r'${var_name}';

const String ERROR_KEY_ABSENT = 'key ${PARAM_KEY_NAME} is missing from ${PARAM_MAP}';
const String ERROR_KEY_IS_NOT_STRING = 'All keys in ${PARAM_MAP} must be String';
const String ERROR_WRONG_TYPE = '${PARAM_VAR_NAME} is ${PARAM_TYPE_WRONG} expected ${PARAM_TYPE_EXPECTED}';

Map<String, dynamic> parse (Map parse, List<Key> keys) {
  var map = new Map<String, dynamic> ();
  if (parse.keys.every(utils.isString)) {
    keys.forEach((Key key) {
      if (parse.containsKey(key.name)) {
        var value = parse[key.name];
        map[key.name] = key.validate(value) ?
            value : 
              throw new ArgumentError(ERROR_WRONG_TYPE
              .replaceFirst(PARAM_VAR_NAME, key.name)
              .replaceFirst(PARAM_TYPE_WRONG,
                MirrorSystem.getName(reflect(parse).type.qualifiedName))
              .replaceFirst(PARAM_TYPE_EXPECTED, 'other'));
      } else {
        map[key.name] = key.defaultValue;
      }
    });
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
      .replaceFirst(PARAM_MAP, parse.toString()));
  }
  return map;
}

Field parseField (Map properties, Map<String, Format> formats) {
  if (properties.keys.every(utils.isString)) {
    Map values = parse(properties, [Key.DEFAULT_VALUE, Key.FORMAT, Key.MAX_NUM, 
                                    Key.MIN_NUM, Key.REQUIRED, Key.TYPE_SCHEMA]);
    
    List<String> fieldFormat = values[Key.FORMAT.name] is String ? [values[Key.FORMAT.name]] : values['format'];
    var found = formats.keys.where((key) => fieldFormat.contains(key));
    
    List<Format> fs = [];
    found.forEach((value) => fs.add(formats[value]));
    
    return new Field(values[Key.DEFAULT_VALUE.name], fs, values[Key.MAX_NUM.name], values[Key.MIN_NUM.name],
        values[Key.REQUIRED.name], values[Key.TYPE_SCHEMA.name]);
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
        .replaceFirst(PARAM_MAP, 'properties'));
  }
}

Format parseFormat (Map properties) {
  if (properties.keys.every(utils.isString)) {
    Map values = parse(properties, 
        [Key.CASE_SENSITIVE, Key.MATCH, Key.MULTI_LINE]);
    return new StringFormat (new RegExp(values[Key.MATCH.name], 
        multiLine: values[Key.MULTI_LINE.name], 
        caseSensitive: values[Key.CASE_SENSITIVE.name]));
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
        .replaceFirst(PARAM_MAP, 'properties'));
  }
}

Map<String, Format> parseFormats (Map formats) {
  if (formats.keys.every(utils.isString)) {
    Map<String, Format> fmts = new Map<String, Format> ();
    
    formats.forEach((String name, format) {
      if (format is Map) {
        if (format.keys.every(utils.isString)) {
          fmts[name] = parseFormat(format);
        } else {
          throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
            .replaceFirst(PARAM_MAP, 'format'));
        }
      } else {
        throw new ArgumentError(ERROR_WRONG_TYPE
          .replaceFirst(PARAM_VAR_NAME, format)
          .replaceFirst(PARAM_TYPE_WRONG,
            MirrorSystem.getName(reflect(format).type.qualifiedName))
          .replaceFirst(PARAM_TYPE_EXPECTED, 'map'));
      }
    });
    return fmts;
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
        .replaceFirst(PARAM_MAP, Key.FORMATS.name));
  }
}

Map<String, Field> parseFields (Map fields, Map<String, Format> formats) {
  Map<String, Field> fs = new Map<String, Field> ();
  
  if (fields.keys.every(utils.isString)) {
    fields.forEach((String name, properties) {
      fs[name] = parseField(properties, formats);
    });
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
        .replaceFirst(PARAM_MAP, Key.FIELDS.name));
  }
  return fs;
}

JSchemaType parseType (Map<String, dynamic> properties, Map<String, Format> formats) {
    Map values = parse(properties, 
        [Key.FIELDS, Key.TYPE_SCHEMA]);
    values[Key.FIELDS.name] = parseFields(values[Key.FIELDS.name], formats);
    
    return new JSchemaType(values[Key.FIELDS.name], values[Key.TYPE_SCHEMA.name]);
}

Map<String, JSchemaType> parseTypes(Map types, Map<String, Format> formats) {
  Map<String, JSchemaType> ts = new Map<String, JSchemaType> ();
  
  if (types.keys.every(utils.isString)) {
    types.forEach((String name, properties) {
      if (properties is Map) {
        if (properties.keys.every(utils.isString)) {
          ts[name] = parseType(properties, formats);
        } else {
          throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
            .replaceFirst(PARAM_MAP, 'properties'));
        }
      } else {
        throw new ArgumentError(ERROR_WRONG_TYPE
          .replaceFirst(PARAM_VAR_NAME, properties)
          .replaceFirst(PARAM_TYPE_WRONG,
            MirrorSystem.getName(reflect(properties).type.qualifiedName))
          .replaceFirst(PARAM_TYPE_EXPECTED, 'map'));
      }
    });
  } else {
    throw new ArgumentError(ERROR_KEY_IS_NOT_STRING
        .replaceFirst(PARAM_MAP, Key.TYPES.name));
  }
  return ts;
}
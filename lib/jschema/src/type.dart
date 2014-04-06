part of jschema;

/**
 * Every [JSchemaType] allows keys:
 * *[fields] Map<String, Field> - Fields of this [JSchemaType]
 * *[type] [String] - Type of this [JSchemaType].
 */
class JSchemaType {
  /**
   * [Map] containing fields
   */
  final Map<String, Field> fields;
  /**
   * type of this [JSchemaType]
   */
  final String type;
  
  JSchemaType(Map<String, Field> this.fields, String this.type);
  
  int get hashCode => fields.hashCode;
  
  operator == (JSchemaType t) => fields == t.fields;
}
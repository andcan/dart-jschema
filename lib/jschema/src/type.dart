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
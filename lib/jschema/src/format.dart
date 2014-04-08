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
 * Every format allows keys:
 * *[match] [String] - String used to verify for matches.
 * *[type] [String] - Type of this [Format].
 */
abstract class Format<T> {
  final T match;
  final String type;
  
  Format(T this.match, String this.type);
  
  int get hashCode => utils.hashCode([match]);
  
  operator == (Format f);
}

/**
 * [Format<RegExp>] implementation
 */
class StringFormat extends Format<RegExp> {
  
  /**
   * Creates a [StringFormat] from given [RegExp]
   */
  StringFormat (RegExp regexp) :
    super(regexp, 'string');
  
  /**
   * Creates a [StringFormat] from given [expression]
   */
  StringFormat.fromString (String expression, {bool caseSensitive: true,
    bool multiLine: false}) :
    super(new RegExp(expression, caseSensitive: caseSensitive, multiLine: multiLine),
        'string');
  
  operator == (StringFormat f) => match.pattern == f.match.pattern && 
      match.isCaseSensitive == f.match.isCaseSensitive &&
      match.isMultiLine == f.match.isMultiLine;
}
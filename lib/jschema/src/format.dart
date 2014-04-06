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
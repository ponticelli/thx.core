package thx.core;

class Ints {
  static var pattern_parse = ~/^[+-]?(\d+|0x[0-9A-F]+)$/i;
  public static function canParse(s : String)
    return pattern_parse.match(s);

  public static inline function clamp(v : Int, min : Int, max : Int) : Int
    return v < min ? min : (v > max ? max : v);

  inline public static function compare(a : Int, b : Int) : Int
    return a - b;

  inline public static function max(a : Int, b : Int) : Int
    return a > b ? a : b;

  inline public static function min(a : Int, b : Int) : Int
    return a < b ? a : b;

  // TODO add proper octal/hex/exp support
  public static function parse(s : String) {
    if (s.substr(0, 1) == "+")
      s = s.substr(1);
    return Std.parseInt(s);
  }

  public static function range(start : Int, ?stop : Int, step = 1) : Array<Int> {
    if (null == stop) {
      stop = start;
      start = 0;
    }
    if ((stop - start) / step == Math.POSITIVE_INFINITY) throw "infinite range";
    var range = [], i = -1, j;
    if (step < 0)
      while ((j = start + step * ++i) > stop) range.push(j);
    else
      while ((j = start + step * ++i) < stop) range.push(j);
    return range;
  }
}
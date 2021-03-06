package thx.core;

import thx.core.Functions.Functions in F;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
#end

/**
`Arrays` provides additional extension methods on top of the `Array` type.

Note that some of the examples imply `using thx.core.Arrays;`.
**/
class Arrays {
/**
Returns `true` if `element` is found in the array.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function contains<T>(array : Array<T>, element : T, ?eq : T -> T -> Bool) : Bool {
    if(null == eq) {
      return array.indexOf(element) >= 0;
    } else {
      for(i in 0...array.length)
        if(eq(array[i], element))
          return true;
      return false;
    }
  }

/**
It returns the cross product between two arrays.

```haxe
var r = [1,2,3].cross([4,5,6]);
trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
```
**/
  public static function cross<T>(a : Array<T>, b : Array<T>) {
    var r = [];
    for (va in a)
      for (vb in b)
        r.push([va, vb]);
    return r;
  }

/**
It produces the cross product of each array element.

```haxe
var r = [[1,2],[3,4],[5,6]].crossMulti();
trace(r); // [[1,3,5],[2,3,5],[1,4,5],[2,4,5],[1,3,6],[2,3,6],[1,4,6],[2,4,6]]
```
**/
  public static function crossMulti<T>(array : Array<Array<T>>) {
    var acopy  = array.copy(),
        result = acopy.shift().map(function(v) return [v]);
    while (acopy.length > 0) {
      var array = acopy.shift(),
          tresult = result;
      result = [];
      for (v in array) {
        for (ar in tresult) {
          var t = ar.copy();
          t.push(v);
          result.push(t);
        }
      }
    }
    return result;
  }

/**
It allows to iterate an array pairing each element with every other element in the array.

The iteration ends as soon as the `callback` returns `false`.
**/
  public static function eachPair<TIn, TOut>(array : Array<TIn>, callback : TIn -> TIn -> Bool)
    for(i in 0...array.length)
      for(j in i...array.length)
        if(!callback(array[i], array[j]))
          return;

/**
It compares the lengths and elements of two given arrays and returns `true` if they match.

An optional equality function can be passed as the last argument. If not provided, strict equality is adopted.
**/
  public static function equals<T>(a : Array<T>, b : Array<T>, ?equality : T -> T -> Bool) {
    if(a == null || b == null || a.length != b.length) return false;
    if(null == equality) equality = F.equality;
    for(i in 0...a.length)
      if(!equality(a[i], b[i]))
        return false;
    return true;
  }

/**
It finds an element in the array using `predicate` and returns it. The element is also
removed from the original array.

If no element satisfies `predicate` the array is left unmodified and `null` is returned.
**/
  public static function extract<T>(a : Array<T>, predicate : T -> Bool) : T {
    for(i in 0...a.length)
      if(predicate(a[i]))
        return a.splice(i, 1)[0];
    return null;
  }

/**
It returns the first element of the array that matches the provided predicate function.
If none is found it returns null.
**/
  public static function first<T>(array : Array<T>, predicate : T -> Bool) : Null<T> {
    for(item in array)
      if(predicate(item))
        return item;
    return null;
  }

/**
It traverses an array of elements. Each element is split using the `callback` function and a 'flattened' array is returned.

```haxe
var chars = ['Hello', 'World'].flatMap(function(s) return s.split(''));
trace(chars); // ['H','e','l','l','o','W','o','r','l','d']
```
**/
  inline public static function flatMap<TIn, TOut>(array : Array<TIn>, callback : TIn -> Array<TOut>) : Array<TOut>
    return flatten(array.map(callback));

/**
It takes an array of arrays and 'flattens' it into an array.

```haxe
var arr = [[1,2,3],[4,5,6],[7,8,9]];
trace(arr); // [1,2,3,4,5,6,7,8,9]
```
**/
  #if js inline #end
  public static function flatten<T>(array : Array<Array<T>>) : Array<T>
    #if js
      return untyped __js__('Array.prototype.concat.apply')([], array);
    #else
      return reduce(array, function(acc : Array<T>, item) return acc.concat(item), []);
    #end

/**
It returns `true` if the array contains zero elements.
**/
  inline public static function isEmpty<T>(array : Array<T>) : Bool
    return array.length == 0;

/**
Same as `Array.map()` but it adds a second argument to the `callback` function with the current index value.
**/
  #if js inline #end
  public static function mapi<TIn, TOut>(array : Array<TIn>, callback : TIn -> Int -> TOut) : Array<TOut> {
    #if js
      return (cast array : { map : (TIn -> Int -> TOut) -> Array<TOut> }).map(callback);
    #else
      var r = [];
      for(i in 0...array.length)
        r.push(callback(array[i], i));
      return r;
    #end
  }

/**
It works the same as `Array.sort()` but returns a sorted copy of the original array.
**/
  public static function order<T>(array : Array<T>, sort : T -> T -> Int) {
    var n = array.copy();
    n.sort(sort);
    return n;
  }

/**
In other libraries it is usually referred as `pluck()`. The method works like a normal `Array.map()`
but instead of passing a function that receives an item, you can pass an expression that defines
how to access to a member of the item itself.

The following two examples are equivalent:

```
var r = ['a','b','c'].plunk(toUppercase());
trace(r); // ['A','B','C']
```

Alternative using traditional `map`.

```
var r = ['a','b','c'].map(function(o) return o.toUppercase());
trace(r); // ['A','B','C']
```

You can use `plunk` on any kind of field including properties and methods and you can even pass arguments
to such functions.

The method is a macro method that guarantees that the correct types and identifiers are used.
**/
  macro public static function plunk<T>(a : ExprOf<Array<T>>, field : Expr) {
    var id = 'o.'+ExprTools.toString(field),
        expr = Context.parse(id, field.pos);
    return macro $e{a}.map(function(o) return ${expr});
  }

/**
Like `plunk` but with an extra argument `i` that can be used to infer the index of the iteration.

```haxe
var r = arr.plunki(increment(i)); // where increment() is a method of the elements in the array
```
**/
  macro public static function plunki<T>(a : ExprOf<Array<T>>, field : Expr) {
    var id = 'o.'+ExprTools.toString(field),
        expr = Context.parse(id, field.pos);
    return macro thx.core.Arrays.mapi($e{a}, function(o, i) return ${expr});
  }

/**
It pushes `value` onto the array if `condition` is true. Also returns the array for easy method chaining.
**/
  public static function pushIf<T>(array : Array<T>, condition : Bool, value : T) {
    if (condition)
      array.push(value);
    return array;
  }

/**
It applies a function against an accumulator and each value of the array (from left-to-right) has to reduce it to a single value.
**/
  inline public static function reduce<TItem, TAcc>(array : Array<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc
    #if js
      return untyped array.reduce(callback, initial);
    #else
      return Iterables.reduce(array, callback, initial);
    #end

/**
It is the same as `reduce` but with the extra integer `index` parameter.
**/
  inline public static function reducei<TItem, TAcc>(array : Array<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc
    #if js
      return untyped array.reduce(callback, initial);
    #else
      return Iterables.reducei(array, callback, initial);
    #end

/**
It returns a copy of the array with its elements randomly changed in position.
**/
  public static function shuffle<T>(a : Array<T>) : Array<T> {
    var t = Ints.range(a.length),
        array = [];
    while (t.length > 0) {
      var pos = Std.random(t.length),
        index = t[pos];
      t.splice(pos, 1);
      array.push(a[index]);
    }
    return array;
  }
}
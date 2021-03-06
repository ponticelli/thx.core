package thx.core;

class Iterables {
  public inline static function eachPair<TIn, TOut>(it : Iterable<TIn>, handler : TIn -> TIn -> Bool)
    return Iterators.eachPair(it.iterator(), handler);

  public inline static function filter<T>(it : Iterable<T>, predicate : T -> Bool) : Array<T>
    return Iterators.filter(it.iterator(), predicate);

  public inline static function find<T, TFind>(it : Iterable<T>, f : T -> Bool)
    return Iterators.find(it.iterator(), f);

  public inline static function first<T, TFind>(it : Iterable<T>, f : T -> Bool)
    return Iterators.first(it.iterator(), f);

  public inline static function isEmpty<T>(it : Iterable<T>) : Bool
    return Iterators.isEmpty(it.iterator());

  public static function isIterable(v : Dynamic) {
    var fields = Types.isAnonymousObject(v) ? Reflect.fields(v) : Type.getInstanceFields(Type.getClass(v));
    if(!Lambda.has(fields, "iterator")) return false;
    return Reflect.isFunction(Reflect.field(v, "iterator"));
  }

  public inline static function map<T, S>(it : Iterable<T>, f : T -> S) : Array<S>
    return Iterators.map(it.iterator(), f);

  public inline static function mapi<T, S>(it : Iterable<T>, f : T -> Int -> S) : Array<S>
    return Iterators.mapi(it.iterator(), f);

  public inline static function order<T>(it : Iterable<T>, sort : T -> T -> Int) : Array<T>
    return Iterators.order(it.iterator(), sort);

  public inline static function reduce<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> TAcc, initial : TAcc) : TAcc
    return Iterators.reduce(it.iterator(), callback, initial);

  public inline static function reducei<TItem, TAcc>(it : Iterable<TItem>, callback : TAcc -> TItem -> Int -> TAcc, initial : TAcc) : TAcc
    return Iterators.reducei(it.iterator(), callback, initial);

  public inline static function toArray<T>(it : Iterable<T>) : Array<T>
    return Iterators.toArray(it.iterator());
}
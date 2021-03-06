package thx.core;

import haxe.PosInfos;
import haxe.CallStack;

/**

**/
class Error #if js extends js.Error #end {
/**
It creates an instance of Error from any value.

If `err` is already an instance of `Error`, it is returned and nothing is created.
**/
  public static function fromDynamic(err : Dynamic, ?pos : PosInfos) : Error {
    if(Std.is(err, Error))
      return cast err;
    return new Error(""+err, null, pos);
  }

#if !js
  public var message(default, null) : String;
#end
  public var pos(default, null) : PosInfos;
  public var stackItems(default, null) : Array<StackItem>;

  public function new(message : String, ?stack : Array<StackItem>, ?pos : PosInfos) {
#if js
    super(message);
#else
    this.message = message;
#end
    if(null == stack) {
      stack = CallStack.exceptionStack();
      if(stack.length == 0)
        stack = CallStack.callStack();
    }
    this.stackItems = stack;
    this.pos = pos;
  }

  public function toString()
    return message + "from: " + pos.className + "." + pos.methodName + "() at " + pos.lineNumber + "\n\n" + CallStack.toString(stackItems);
}
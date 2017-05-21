package;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class Macros {
	// http://stackoverflow.com/questions/857439/internet-explorer-and-javascript-event-currenttarget
	macro public static function event_preventDefault() return macro @:mergeBlock {
		if ((e: Dynamic).preventDefault) // prevent haxe $bind
			e.preventDefault();
		else
			untyped e.returnValue = false;
	}

	macro public static function event_stopPropagation() return macro @:mergeBlock{
		if ((e: Dynamic).stopPropagation)
			e.stopPropagation();
		else
			untyped e.cancelBubble = true;
	}
}
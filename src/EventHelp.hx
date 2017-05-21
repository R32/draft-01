package;

import js.html.Event;
import js.html.EventTarget;
import haxe.Constraints.Function;
import haxe.DynamicAccess;

class EventHelp {

	public static function addEvent(event: String, elem: EventTarget, func: Function) {
		if ((elem: Dynamic).addEventListener)
			elem.addEventListener(event, func);
		else
			untyped elem.attachEvent("on" + event, func);
	}

	public static function removeEvent(event: String, elem: EventTarget, func: Function) {
		if ((elem: Dynamic).removeEventListener)
			elem.removeEventListener(event, func);
		else
			untyped elem.detachEvent("on" + event, func);
	}
}

package ui;

import js.html.DOMElement;
import js.html.MouseEvent;
import js.Browser.document;

// only simple Drag
class Drag {

	static var dragging: Bool;
	static var sx: Int;
	static var sy: Int;
	static var callb: Int->Int->Bool->Void; // (dx, dy, isEnd)

	public static var ready(default, null): Bool;

	public static function start(e: MouseEvent, f: Int->Int->Bool->Void) {
		if (!ready) attach();
		sx = e.screenX;
		sy = e.screenY;
		callb = f;
		dragging = true;
	#if !no_throttle
		startThrottle();
	#end
	}

	public static function stop() {
		dragging = false;
		callb = null;
	#if !no_throttle
		stopThrottle();
	#end
	}

	public static function attach () {
		if (ready) return;
		var elem = document;

		if ((elem: Dynamic).addEventListener) {
			elem.addEventListener("mousemove", onDocMouseOver, true);
			elem.addEventListener("mouseup"  , onDocMouseUp, true);
			elem.addEventListener("selectstart"  , onSelectstart, true);
		} else untyped {
			elem.attachEvent("onmousemove", onDocMouseOver);
			elem.attachEvent("onmouseup"  , onDocMouseUp);
			elem.attachEvent("onselectstart", onSelectstart);
		}
		ready = true;
	}

	public static function detach () {
		if (!ready) return;
		var elem = document;
		if ((elem: Dynamic).removeEventListener) {
			elem.removeEventListener("mousemove", onDocMouseOver, true);
			elem.removeEventListener("mouseup"  , onDocMouseUp, true);
			elem.removeEventListener("selectstart", onSelectstart, true);
		} else untyped {
			elem.detachEvent ("onmousemove", onDocMouseOver);
			elem.detachEvent ("onmouseup"  , onDocMouseUp);
			elem.detachEvent ("onselectstart", onSelectstart);
		}
		ready = false;
	}

	static function onDocMouseOver(e: MouseEvent) {
		if (!dragging || callb == null) return;
		Macros.event_preventDefault();
		Macros.event_stopPropagation();
	#if !no_throttle
		if (!pass) return;
	#end
		if (e == null) untyped e = window.event;
		try {
			callb(e.screenX - sx, e.screenY - sy, false);
		} catch (err: Dynamic) {
			stop();
		}
	#if !no_throttle
		pass = false;
	#end
	}

	static function onDocMouseUp(e: MouseEvent) {
		if (!dragging) return;
		if (e == null) untyped e = window.event;
		if (callb != null) {
			try callb(e.screenX - sx, e.screenY - sy, true) catch (err: Dynamic) { }
		}
		stop();
		Macros.event_preventDefault();
		Macros.event_stopPropagation();
	}

	static function onSelectstart(e: Dynamic) {
		if (!dragging) return;
		if (e == null) e = untyped window.event;
		Macros.event_stopPropagation();
		Macros.event_preventDefault();
	}

#if !no_throttle
	static var tid :Int = 0;
	static var pass: Bool = false;
	static function onInterval() pass = true;
	static inline function startThrottle() tid = untyped setInterval(onInterval, THROTTLE);
	static inline function stopThrottle() untyped clearInterval(tid);
	static inline var THROTTLE = 50;
#end
}
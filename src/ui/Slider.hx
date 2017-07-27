package ui;

import js.html.DOMElement;
import js.html.MouseEvent;
import js.Browser.document;

class Slider {

	static inline var THUMB_WIDTH = 20; // see style.hss

	var node : DOMElement;
	var rail : DOMElement;
	var thumb: DOMElement;

	var pos: Int;
	var min: Int;
	var max: Int;

	var width(default, set): Int;
	inline function set_width(w: Int):Int {
		width = w;
		node.style.width = w + "px";
		return w;
	}

	public var value(default, null): Int;          // 0 ~ 100

	inline function per():Float return (width - THUMB_WIDTH) / 100;

	public function new(w: Int, dom: DOMElement, limit_min = 0, limit_max = 100) {
		node = dom;
		rail = dom.querySelector(".rail");
		thumb = dom.querySelector(".thumb");
		thumb.onmousedown = onThumbDown;
		node.onclick = onClick;
		width = w >= (50 + THUMB_WIDTH) ? w : 120;
		min  = Ut.imax(limit_min, 0);
		max  = Ut.imin(limit_max, 100);
		update(max, true);
	}

	function update(v: Int, isEnd: Bool) {
		var p = Ut.f2i(v * per());
		if (value != v) {
			this.thumb.style.left = p + "px";
			this.rail.style.width = p + "px";
			this.value = v;
		}
		if (isEnd) pos = p;
		onChange(v, isEnd);
	}

	public dynamic function onChange(v: Int, b: Bool): Void {}

	public function destory() {
		rail = null;
		thumb.onmousedown = null;
		thumb = null;
		node.onclick = null;
		node = null;
	}

	function onThumbDown(e: MouseEvent) {
		if (e == null) untyped e = window.event;
		Macros.event_stopPropagation();
		Macros.event_preventDefault();
		Drag.start(e, onDragging);
	}

	function onDragging(x: Int, y: Int, isEnd: Bool) {
		var v = Ut.iclamp(Ut.f2i((pos + x) / per()), min, max);
		if (isEnd == false && v == value) return;
		update(v, isEnd);
	}

	function onClick(e: MouseEvent) {
		if (e == null) untyped e = window.event;
		var target = e.target == null ? (e: Dynamic).srcElement : e.target;
		if (target == node || target == rail) {
			var v = Ut.iclamp(Ut.f2i(e.offsetX * 100 / width), min, max);
			update(v, true);
		}
		Macros.event_stopPropagation();
	}

	public static var MARK =
	'<div class="r-slider">
		<span class="rail"></span>
		<span class="thumb"></span>
	</div>';
}
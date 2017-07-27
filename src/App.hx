package;

import js.Browser.document;
import js.Browser.window;
import js.html.Event;
import StringTools.hex;
import ui.Drag;
import Data;

class App {

	static var clientWidth = 0;

	static function main() {
		window.onresize = onresize;
		onresize();
		var slider = new ui.Slider(220, document.getElementById(Home.ids.test), 5);
		slider.onChange = function(v, b) {
			trace(b, Ut.f2i(v / 5) * 5); // multi
		}
	}

	static function onresize() {
		if (document.documentElement.clientWidth == clientWidth) return;
		clientWidth = document.documentElement.clientWidth;
		var node = document.getElementById(Home.ids.mainContainer);
		node.style.width = (clientWidth - node.offsetLeft) + "px";
		trace("onresize: " + (clientWidth - node.offsetLeft));
	}

	static function rand() {
		return Std.int(Math.random() * 0xFFFF);
	}
}
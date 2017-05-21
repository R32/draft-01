package;

import js.Browser.document;
import js.Browser.window;
import js.html.Event;
import StringTools.hex;
import ui.Drag;

class App {

	static function main() {
		window.onresize = onresize;
		onresize();
		var slider = new ui.Slider(220, document.getElementById(Home.test), 5);
		slider.onChange = function(v) {
			trace(Ut.f2i(v / 5) * 5); // multi
		}
	}

	static function onresize() {
		var clientWidth = document.documentElement.clientWidth;
		var node = document.getElementById(Home.mainContainer);
		node.style.width = (clientWidth - node.offsetLeft) + "px";
		trace(clientWidth - node.offsetLeft);
	}


	static function rand() {
		return Std.int(Math.random() * 0xFFFF);
	}
}
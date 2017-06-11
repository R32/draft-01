package;

import js.Browser.document;
import js.Browser.window;
import js.html.Event;
import StringTools.hex;
import ui.Drag;
import Data;

class App {

	static function main() {
		window.onresize = onresize;
		onresize();
		var slider = new ui.Slider(220, document.getElementById(Home.ids.test), 5);
		slider.onChange = function(v) {
			trace(Ut.f2i(v / 5) * 5); // multi
		}

		var p = new c.Parse(["ab", "abc", "abb", "abcd", "abce"]);
		trace(p.toString());
		trace("\n".code);

		//var cl = new CommitList();
		var c0 = Commit.ofk(1, 100, null);
		var c1 = Commit.ofk(2, 200, null);
		var c2 = Commit.ofa([3, 4, 5], 300, null);
		var c3 = Commit.ofk(4, 400, null);
		var c4 = Commit.ofk(5, 500, null);
		var ca = new CommitList();
		ca.push(c0);
		ca.push(c1);
		ca.push(c2);
		ca.push(c3);
		ca.push(c4);

		for (c in ca) trace(c);
		ca.rev();
		trace("rev...");
		for (c in ca) trace(c);

		//cl.push({})
	}

	static function onresize() {
		var clientWidth = document.documentElement.clientWidth;
		var node = document.getElementById(Home.ids.mainContainer);
		node.style.width = (clientWidth - node.offsetLeft) + "px";
		trace(clientWidth - node.offsetLeft);
	}


	static function rand() {
		return Std.int(Math.random() * 0xFFFF);
	}
}
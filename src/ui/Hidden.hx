package ui;

import js.html.DOMElement;
import js.Browser.document;

class Hidden {

	static var dom: DOMElement;
	static inline var DOM_ID = "hidden_box";

	public static function add(node: DOMElement): Void {
		if (dom == null) {
			dom = document.getElementById(DOM_ID);
			if (dom == null) { Home.
				dom = document.createElement("div");
				dom.setAttribute("id", DOM_ID);
				dom.style.cssText = "position: absolute; display: none; bottom: 0; width: 0; height: 0; overflow: hidden;";
				document.body.appendChild(dom);
			}
		}
		dom.appendChild(node);
	}
}
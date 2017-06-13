package c;

import Data;

/**
String -> [[v,k0, k1, k2], [], []]

*/
class Parse {

	var sa: Array<String>;
	var pos : Int;
	var pmin: Int;
	var pmax: Int;



	public function new(sa: Array<String>) {
		sa.sort(function(a, b) {
			return a.length < b.length ? 1 : -1;
		} );
		this.sa = sa;
	}

	public function make(s: String):Commit {
		return null;
	}

	public inline function isDigit(i) {
		return i >= "0".code && i <= "9".code;
	}

	public inline function isSpace(c) {
		// space, tab
		return c == " ".code || c == "\t".code;
	}

	public inline function isIgnore(c) {
		return c == 13; // CR
	}


	public inline function toString() {
		return sa.toString();
	}
}
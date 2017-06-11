package;

class Ut {

	public static inline function f2i(f: Float) return Std.int(f + 0.0000001);

	public static inline function iabs( i : Int ) return i < 0 ? -i : i;

	public static inline function imax( a : Int, b : Int ) return a < b ? b : a;

	public static inline function imin( a : Int, b : Int ) return a > b ? b : a;

	public static inline function iclamp( v : Int, min : Int, max : Int ) return v < min ? min : (v > max ? max : v);



	@:pure public static function arrayEq<T>(a:Array<T>, b: Array<T>): Bool {
		//if (a == null || b == null) return false;
		if (untyped __js__("a === b")) return true;
		if (a.length != b.length) return false;
		var len = a.length;
		var i = 0;
		while (i < len) {
			if (untyped __js__("{0} === {1}", a[i], b[i])) return false;
			++i;
		}
		return true;
	}
}
package;

/**
top = {
	attrs : {
		names: []                // 包含所有姓名, 如果这个属性不存在, 将使用另内嵌的一个姓名列表
	},
	datas : {
		period_0 : {
			time: timestamp,
			padd: [length=50]    // 补数,

			list: [
				{
					name  : "",
					ctime : timestamp,
					?meta : [],  // 可选, 一些备注
					d1: {        // 数据, 使用单链表形式
						v: Int,
						?a: [],  // 优先于 k 值
						?k: Int, // 如果 a 存在, 则忽略这个
						next: d2
					}
				},
				{}
				{}
			]
		},
		period_1 : {},
		period_2 : {},
		period_3 : {},
	}
};

count: {            // 累加器, 这些数据只存在于运行时
	name_0: []      // 使用固定数组
	name_0: [],
	name_0: [],
	name_0: [],
}


每一次 Save 和 Load 时, 只处理单个的 period_n 对象.
*/
class Data {
}


private typedef TCommit = {
	var v: Int;
	var n: Commit;
	@:optional var a: Array<Int>;
	@:optional var k: Int;
}

abstract Commit(TCommit) from TCommit to TCommit {

	public var next(get, set): Commit;
	inline function get_next() return this.n;
	inline function set_next(n) return this.n = n;

	public var value(get, set): Int;
	inline function get_value() return this.v;
	inline function set_value(v) return this.v = v;

	public inline function isArray():Bool return this.a != null;

	public inline function toString(): String
		return '[value: $value, key: ${isArray() ? this.a.join(",") : this.k + ""}]';

	public static inline function ofa(arr, value, next = null):Commit return {
		v: value,
		n: next,
		a: arr,
	}
	public static inline function ofk(key, value, next = null):Commit return {
		v: value,
		n: next,
		k: key,
	}

	@:pure public static function eq(a: TCommit, b: TCommit): Bool {
		if (untyped __js__("a === b")) return true;
		var t = (a: Commit).isArray();
		if (t != (b: Commit).isArray() || a.v != b.v) return false;
		if (t) {
			return Ut.arrayEq(a.a, b.a);
		} else {
			return a.k == b.k;
		}
	}
}

class CommitList {

	var h: Commit;
	var q: Commit;

	public var length(default, null): Int;

	public function new () {
		h = null;
		q = null;
	}

	public function push(c: Commit) {
		c.next = h;
		h = c;
		if( q == null ) q = c;
	}

	public function pop(): Commit {
		if (h == null) return null;
		var x = h;
		h = h.next;
		if (h == null) q = null;
		return x;
	}

	public function remove(c: Commit) {
		var prev: Commit = null;
		var lop = h;
		while (lop != null) {
			if (Commit.eq(lop, c)) {
				if (prev == null)
					h = lop.next;
				else
					prev.next = lop.next;
				if (q == lop)
					q = prev;
				return true;
			}
			prev = lop;
			lop = lop.next;
		}
		return false;
	}

	public function rev() {
		var x = h;
		h = null;
		q = null;
		while (x != null) {
			var next = x.next;
			push(x);
			x = next;
		}
	}

	public inline function iterator() {
		return new CommitListIterator(h);
	}
}


private class CommitListIterator {

	var head: Commit;

	public inline function new(h) head = h;

	public inline function hasNext() return head != null;

	public inline function next():Commit {
		var val = head;
		head = head.next;
		return val;
	}
}

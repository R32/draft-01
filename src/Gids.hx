package;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.PositionTools.here;
import StringTools.hex;
using haxe.macro.TypeTools;

class MyMacro {
	public static function make() {
		var url:String;
		var gids:ClassType;
		var pos = Context.currentPos();

		switch(Context.getLocalType()){
			case TInst(t, [TInst(c, _)]):
				if (StringTools.fastCodeAt(c.toString(), 0) == "S".code){
					gids = t.get();
					url = c.toString().substr(1);
				}
			default:
				Context.error("Class expected", pos);
		}
		if (url == null || url == "") Context.error("Class expected", pos);

		var pack = ["_gids"];
		var name = "X" + hex(haxe.crypto.Crc32.make(haxe.io.Bytes.ofString(url)));
		var modfullname = "_gids." + name;
		var http = url.substr(0, 4) == "http";
		var ftext = http ? haxe.Http.requestUrl(url) : sys.io.File.getContent(url);
		var fstart = ftext.indexOf("<body");
		if (fstart > -1) ftext = ftext.substr(fstart);

		// get id
		var ri = ~/ id="([A-Za-z_][A-Za-z0-9_-]+)"/;
		var ids = new List<String>();
		var text = ftext;
		while (ri.match(text)) {
			var id = ri.matched(1);
			ids.remove(id);
			ids.push(id);
			text = ri.matchedRight();
		}
		var tdi: TypeDefinition = {
			isExtern: true,
			pack: pack,
			name: name + "i",
			pos: pos,
			kind: TDClass(null, [], false),
			fields: []
		};
		pushes(tdi.fields, ids, pos);

		// get class
		var rc = ~/ class="([A-Za-z_][ A-Za-z0-9_-]+)"/;
		var cls = new List<String>();
		text = ftext;
		while (rc.match(text)) {
			var cs = rc.matched(1);
			var a = cs.split(" ");
			for (v in a) {
				if (v == "") continue;
				cls.remove(v);
				cls.push(v);
			}
			text = rc.matchedRight();
		}
		var tdc: TypeDefinition = {
			isExtern: true,
			pack: pack,
			name: name + "c",
			pos: pos,
			kind: TDClass(null, [], false),
			fields: []
		};
		pushes(tdc.fields, cls, pos);

		var module: TypeDefinition = {
			isExtern: true,
			pack: pack,
			name: name,
			pos: pos,
			kind: TDClass(null, [], false),
			fields: [{
				name : "ids",
				pos  : pos,
				kind : FVar(TPath({pack: tdi.pack, name: tdi.name})),
				access : [AStatic],
			}, {
				name : "cls",
				pos  : pos,
				kind : FVar(TPath({pack: tdc.pack, name: tdc.name})),
				access : [AStatic],
			}]
		};

		Context.defineModule(modfullname, [module, tdi, tdc]);
		if (!http) Context.registerModuleDependency(modfullname, url);
		return Context.getType(modfullname).toComplexType();
	}

	static function pushes(fields: Array<Field>, list: List<String>, pos: Position): Void {
		var CTString = macro :String;
		for (str in list) {
			var name = str.indexOf("-") == -1 ? str : str.split("-").join("_");
			fields.push({
				name: name,
				kind: FProp("get", "never", CTString),
				pos: pos,
			});
			fields.push({
				name: "get_" + name,
				access: [AInline, APrivate],
				pos: pos,
				kind: FFun({
					args: [],
					ret : CTString,
					expr: macro {
						return $v{str};
					}
				})
			});
		}
	}
}
#else
@:genericBuild(Gids.MyMacro.make())
#end
@:dce class Gids<Const> { }
/**
http://code.haxe.org/category/macros/completion-from-url.html

example:

```haxe
@:eager typedef Home = Gids<"bin/Index.html">;
```

similar:

```haxe
extern class Home {
	static var ids: Home_Ids;
	static var cls: Home_Cls;
}
extern class Home_Ids {
	var header(get, never): Int;
	private inline function get_value(): Int return "header";
}
extern class Home_Cls {}
```
*/
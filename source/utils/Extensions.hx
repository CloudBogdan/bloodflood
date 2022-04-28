package utils;

import flixel.FlxBasic;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class ArrayExtensions {
    public static inline function find<T>(a:Array<T>, f:T->Bool):Null<T> {
        var res = a.filter(f);
        if (res.length == 0)
            return null;
        else
            return res[0];
    }
}

class FlxTypedGroupExtensions {
    public static inline function removeDead<T:FlxBasic>(g:FlxTypedGroup<T>) {
        g.forEachDead(child-> {
            g.remove(child);
        });
    }
}
class FlxGroupExtensions {
    public static inline function removeDead<T:FlxBasic>(g:FlxTypedGroup<T>) {
        g.forEachDead(child-> {
            g.remove(child);
        });
    }
}
class FlxPointExtensions {
    public static inline function squareDistance(p:FlxPoint, point:FlxPoint):Float {
        var dx = p.x - point.x;
        var dy = p.y - point.y;
        return dx*dx + dy*dy;
    }
}
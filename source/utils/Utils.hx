package utils;

import flixel.FlxG;

class Utils {
    public static function boolToInt(bool:Bool):Int {
        return bool ? 1 : 0;
    }

    public static function log(data:Dynamic) {
        var dt = Std.string(Date.now().getTime());
        FlxG.log.add('${ dt.substr(0, dt.length-4) } $data');
    }
}
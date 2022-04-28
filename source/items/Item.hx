package items;

import entities.Entity;
import flixel.FlxObject;
import haxe.Rest;

class Item {
    var target:Entity;
    
    public function new(Target:Entity) {
        target = Target;
    }

    public function update() {}
    public function use(args:Rest<Any>):Bool {
        return false;
    }
}
package items.swords;

import effects.Effects;
import entities.Entity;
import haxe.Rest;

class DummySword extends Sword {
    public function new(Target:Entity) {
        super(Target);

        range = 6;
        damage = 1;
    }

    override function use(args:Rest<Any>):Bool {
        if (isAttacking)
            return false;

        target.playAnimation(ATTACK_DOWN);
        
        var pos = getPosition(6);
        var entities = hit(pos.x, pos.y, 20);

        Effects.spawnDummySwordSwipeEffect(
            pos.x, pos.y,
            target.flipX, false
        );
        
        return entities.length > 0;
    }
}

@:enum abstract DummySwordAnimation(String) to String {
    var ATTACK_DOWN = "attack-down";
}
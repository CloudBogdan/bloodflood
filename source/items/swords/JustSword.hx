package items.swords;

import effects.Effects;
import entities.Entity;
import entities.Player;
import flixel.FlxG;
import flixel.math.FlxVector;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Rest;
import utils.Utils;

class JustSword extends Sword {
    static final COMBO_DURATION:Float = 1;
    
    // Settings
    public var combo:Int = 0;

    // Timers
    var comboTimer = new FlxTimer();
    
    public function new(Target:Entity) {
        super(Target);

        damage = 1;
        target = Target;
    }

    override function update() {
        super.update();

        isCrit = combo == 3;
        
        comboTimer.onComplete = t-> {
            combo = 0;
        }
    }
    
    override function use(args:Rest<Any>) {
        if (target.isAttacking)
            return false;

        if (combo >= 3)
            combo = 0;
        combo ++;

        var force = 40;

        if (combo == 1)
            target.playAnimation(ATTACK_L);
        else if (combo == 2)
            target.playAnimation(ATTACK_R);
        else if (combo == 3) {
            target.playAnimation(ATTACK_COMBO);
            force = 100;
        }
        
        var pos = getPosition(4 + force/20);
        var entities = hit(pos.x, pos.y, force);
        var deadEntities = entities.filter(e-> !e.alive);
        comboTimer.start(COMBO_DURATION);

        if (deadEntities.length > 0) {
            if (target is Player) {
                // Slow motion, only for player
                FlxG.camera.shake(.03, .1);
                FlxTween.num(.2, 1, .1, { ease: FlxEase.linear, startDelay: .1 }, v-> FlxG.timeScale = v);
            }

            for (dead in deadEntities) {
                var dir = new FlxVector(
                    dead.getMidpoint().x - target.getMidpoint().x,
                    dead.getMidpoint().y - target.getMidpoint().y
                ).normalize();
                
                dead.flipAt(target.getMidpoint().x);
                dead.drag.set(40, 40);
                dead.acceleration.set(0, 0);
                dead.velocity.set(dir.x * 200, dir.y * 200 - 50);
            }
        }

        Effects.spawnSwordSwipeEffect(
            pos.x, pos.y,
            target.flipX,
            combo == 2,
            combo == 3
        );

        return entities.length > 0;
    }

    override function getDamage():Int {
        return damage + (combo == 3 ? 2 : 0);
    }
}

@:enum abstract JustSwordEntityAnimation(String) to String {
    var ATTACK_L = "attack-l";
    var ATTACK_R = "attack-r";
    var ATTACK_COMBO = "attack-combo";
}
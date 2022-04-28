package items.swords;

import entities.Enemy;
import entities.Entity;
import entities.Player;
import flixel.math.FlxPoint;
import haxe.Rest;
import states.PlayState;
import utils.Utils;

class Sword extends Item {
    // Settings
    var range:Int = 12;
    public var damage:Int = 2;

    // Is..
    var isCrit:Bool = false;
    public var isAttacking:Bool = false;
    
    public function new(target:Entity) {
        super(target);
    }
    
    function hit(X:Float, Y:Float, force:Float, pushEntities:Bool=true):Array<Entity> {
        if (!target.alive) return [];

        // Force
        target.acceleration.set(0, 0);
        target.velocity.set(0, 0);
        target.velocity.x += target.flipX ? -force : force;
        
        // Hit entities
        var entities = PlayState.entitiesGroup.members.filter(entity-> {
            if (!entity.alive)
                return false;
            
            var isInRange = new FlxPoint(X, Y).distanceTo(entity.getMidpoint()) < range;
            var isPlayer = entity is Player;
            var isEnemy = entity is Enemy;
            var thisIsPlayer = target is Player;
            var thisIsEnemy = target is Enemy;

            return isInRange && (thisIsEnemy && isPlayer || thisIsPlayer && isEnemy);
        });

        for (entity in entities) {    
            entity.takeDamage(getDamage(), target.getMidpoint(), isCrit);
            if (pushEntities)
                entity.pushFrom(target.getMidpoint());
        }

        return entities;
    }
    function getPosition(offsetX:Float=4, offsetY:Float=0):FlxPoint {
        return new FlxPoint(
            target.getMidpoint().x + (target.flipX ? -(offsetX-1) : offsetX),
            target.getMidpoint().y + offsetY
        );
    }

    public function getDamage():Int {
        return damage;
    }
}
package items.guns;

import bullets.Bullets;
import effects.Effects;
import entities.Entity;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import haxe.Rest;

class JustPistol extends Item {
    // Settings
    public var recoil:Float = 50; 
    public var reloadTime:Float = .2; 
    
    // Timers
    public var reloadTimer = new FlxTimer();
    
    public function new(Target:Entity) {
        super(Target);
    }

    override function use(args:Rest<Any>):Bool {
        if (target.isAttacking || reloadTimer.active)
            return false;

        var dir:FlxPoint = args[0];
        
        if (dir.x != 0)
            target.acceleration.y = 0;
        target.velocity.y += -recoil * dir.y;
        target.velocity.x += -recoil * dir.x;

        reloadTimer.start(reloadTime);
        
        Effects.spawnShootEffect(
            target.getMidpoint().x + 4*dir.x,
            target.getMidpoint().y + 4*dir.y
        );
        Bullets.shootJustBullet(target.getMidpoint().x, target.getMidpoint().y, dir);
        
        return true;
    }
}
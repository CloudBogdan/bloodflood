package effects.members;

import flixel.FlxG;
import flixel.math.FlxVector;

class PoofEffect extends Emitter {
    public function new(X:Float, Y:Float, direction:FlxVector, force:Float=1) {
        super(X, Y, 6);

        var vel = new FlxVector(direction.x, direction.y).normalize().scale(30*force);

        particleFrames = ()-> FlxG.random.bool(50) ? [2, 3, 4, 5] : [2, 2, 3, 4, 5];
        particleFrameRate = ()-> FlxG.random.int(5, 8);
        speed.set(0, 0);
        drag.set(100, 100);
        velocity.set(-50+vel.x, -30+vel.y, 50+vel.x, 30+vel.y);
        
        createParticles();
        start(true);
    }
}
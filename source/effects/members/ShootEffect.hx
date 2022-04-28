package effects.members;

import flixel.FlxG;

class ShootEffect extends Emitter {
    public function new(X:Float, Y:Float) {
        super(X, Y, 3);

        particleFrames = ()-> FlxG.random.bool(50) ? [3, 4, 5] : [3, 3, 4, 5];
        speed.set(0, 0);
        drag.set(100, 100);
        velocity.set(-30, -30, 30, 30);
        
        createParticles();
        start();
    }
}
package effects.members;

import flixel.FlxG;

class SparksEffect extends Emitter {
    public function new(X:Float, Y:Float, Count:Int=2, FlipX:Bool, Color:Int=0xFFFF0000) {
        super(X-3, Y-3, Count);

        particleFrames = ()-> Emitter.sparksFrames();
        velocity.set(FlipX ? -40 : 20, -20, FlipX ? -20 : 40, 20);
        setSize(6, 6);
        drag.set(120, 120);
        color.set(Color);
        createParticles();

        start();
    }
}
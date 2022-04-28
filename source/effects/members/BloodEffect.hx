package effects.members;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxVector;
import utils.Color;

class BloodEffect extends Emitter {
    public function new(X:Float, Y:Float, count:Int, direction:FlxVector) {
        super(X, Y, FlxG.random.int(4+count, 6+count));

        particleFrames = ()-> Emitter.largeSparksFrames();
        particleFrameRate = ()-> 10;
        speed.set(0, 0);
        velocity.set(
            -60, -60,
            60, 20
        );
        acceleration.active = false;
        drag.set(100, 100);
        color.set(Color.RED);
        
        createParticles(part-> {
            part.acceleration.set(0, 180);
        });
        start(true);
    }
}

private class Part extends FlxParticle {
    public function new() {
        super();

        loadGraphic(AssetPaths.particle__png, true, 8, 8);
        acceleration.set(0, 260);
        setSize(1, 1);
        offset.set(3, 2);
    }

    override function update(elapsed:Float) {
        if (isTouching(DOWN))
            velocity.x = 0;
        
        super.update(elapsed);
    }
}
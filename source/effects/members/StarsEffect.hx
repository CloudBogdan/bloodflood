package effects.members;

import flixel.FlxSprite;

class StarsEffect extends Emitter {
    public function new(X:Float, Y:Float) {
        super(X, Y, 100);

        particleFrames = ()-> Emitter.starsFrames();
        velocity.set(-60, -60, 60, 60);
        drag.set(120, 120);
        color.active = false;
        createParticles(Emitter.randomPartColor);
    }

    public function updateProps(target:FlxSprite, Emitting:Bool, maxFrequency:Bool) {
        setPosition(target.getMidpoint().x, target.getMidpoint().y);
        emitting = Emitting;
        frequency = maxFrequency ? .01 : .1;
    }
}
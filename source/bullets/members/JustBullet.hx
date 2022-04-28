package bullets.members;

import effects.Effects;
import effects.Emitter;
import effects.Trail;
import flixel.math.FlxVector;
import objects.MySprite;
import states.PlayState;
import utils.Color;

class JustBullet extends Bullet {
    var emitter:Emitter;
    
    public function new(X:Float=0, Y:Float=0, ?Direction:FlxVector) {
        super(X, Y, Direction);

        // Settings
        flySpeed = 300;
        damage = 1;
        
        // Graphic
        loadGraphic(AssetPaths.just_bullet__png, false, 8, 8);
        setSize(5, 5);
        offset.set(1, 1);
        origin.set(3.5, 3.5);

        setPosition(X-width/2, Y-height/2);

        // Children
        emitter = new Emitter(x, y, 100);
        emitter.particleFrames = ()-> Emitter.starsFrames();
        emitter.particleFrameRate = ()-> 16;
        emitter.velocity.set(-30 + direction.x*30, -30 + direction.y*30, 30 + direction.x*30, 30 + direction.y*30);
        emitter.drag.set(120, 120);

        emitter.color.active = false;
        emitter.createParticles(Emitter.randomPartColor);
        emitter.start(false, .1);

        PlayState.subEffectsGroup.add(emitter);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        
        color = MySprite.randomColor();
        emitter.setPosition(getMidpoint().x, getMidpoint().y);
    }
    override function explode(effect:Bool = true) {
        super.explode(effect);

        emitter.emitting = false;
    }
}
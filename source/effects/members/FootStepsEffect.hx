package effects.members;

import flixel.FlxG;
import utils.Color;

// class FootStepsEffect extends SpriteEffect { 
//     public function new(X:Float, Y:Float, FlipX:Bool) {
//         super(X, Y);

//         loadAnimation(AssetPaths.foot_steps_effect__png, 5);        
//         flipX = FlipX;

//         setup(X-4, Y-8);
//     }
// }
class FootStepsEffect extends Emitter { 
    public function new(X:Float, Y:Float, FlipX:Bool) {
        super(X, Y+1, FlxG.random.int(1, 2));
        
        particleFrames = ()-> Emitter.poofFrames();
        particleFrameRate = ()-> FlxG.random.int(8, 10);
        if (!FlipX)
            velocity.set(
                20, -26,
                34, -4
            );
        else
            velocity.set(
                -34, -26,
                20, -4
            );
        drag.set(120, 120);
        color.set(Color.WHITE);
        
        createParticles();
        start(true);
    }
}
package effects.members;

import flixel.FlxSprite;
import flixel.util.FlxTimer;

class SpriteEffect extends FlxSprite {
    static inline final NORMAL = "normal";
    
    var animationSheetWidth:Int = 5;
    var frameRate:Int = 12;
    
    public function new(X:Float, Y:Float) {
        super(0, 0);

        pixelPerfectPosition = true;

        allowCollisions = NONE;
        immovable = true;
    }

    function setup(X:Float, Y:Float, animationName:String=NORMAL) {
        setPosition(X, Y);
        animation.play(animationName);
    }
    
    function loadAnimation(graphics:String, framesCount:Int, width:Int=8, height:Int=8) {
        loadGraphic(graphics, true, width, height);
        animation.add(NORMAL, [for (i in 0...framesCount) i], frameRate, false);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (animation.finished) {
            kill();
        }
    }
}

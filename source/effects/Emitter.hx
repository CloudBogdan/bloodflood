package effects;

import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxColor;

using utils.Extensions.FlxTypedGroupExtensions;

class Emitter extends FlxEmitter {
    public var particlesCount:Int = 10;
    public var particleFrames:()->Array<Int> = ()-> [0, 1, 2, 3, 4, 5];
    public var particleFrameRate:()->Int = ()-> 8;
    
    public function new(X:Float=0, Y:Float=0, count:Int=10) {
        super(X, Y);

        launchMode = SQUARE;
        allowCollisions = NONE;

        particlesCount = count;
    }
    
    public function createParticles(?partRule:FlxParticle->Void, ?customPart:()->FlxParticle) {
        for (_ in 0...particlesCount) {
            var part = customPart != null ? customPart() : new FlxParticle();
            part.loadGraphic(AssetPaths.particle__png, true, 8, 8);
            part.animation.add("normal", particleFrames(), particleFrameRate(), false);
            part.animation.play("normal");
            part.exists = false;
            part.pixelPerfectPosition = true;

            if (partRule != null)
                partRule(part);
            
            add(part);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (members.length <= 0)
            kill();
    }

    // Static
    public static inline function sparksFrames():Array<Int> {
        return FlxG.random.bool(50) ? [7, 8,8, 9] : [7,7, 8, 9];
    }
    public static inline function largeSparksFrames():Array<Int> {
        return FlxG.random.bool(50) ? [6, 7,7, 8, 9] : [6,6, 7, 8, 9];
    }
    public static inline function starsFrames():Array<Int> {
        return FlxG.random.bool(50) ? (FlxG.random.bool(50) ? [7, 7, 8, 9] : [7, 7, 7, 8, 9]) : (FlxG.random.bool(50) ? [3, 3, 4, 5] : [3, 3, 3, 4, 5]);
    }
    public static inline function poofFrames():Array<Int> {
        return FlxG.random.bool(50) ? [2, 3, 4, 5] : [2, 2, 3, 4, 5];
    }
    
    public static inline function randomPartColor(part:FlxParticle) {
        part.color = FlxColor.fromHSL(FlxG.random.int(0, 360), 1, .5, .6);
    }
}
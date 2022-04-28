package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import utils.Config;

class MySprite extends FlxSprite {
    // Settings
    var animationSheetWidth:Int = 5;

    var animationPriority:Map<String, Array<Dynamic>> = [];
    var animationTimeline:Map<String, Map<Int, ()->Void>> = [];
    var lastAnimFrame:Int = -2;
    
    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        var timeline = animationTimeline.get(animation.name);
        if (timeline != null) {
            if (lastAnimFrame != animation.frameIndex) {
                lastAnimFrame = animation.frameIndex;
                var frame = timeline.get(animation.curAnim.curFrame);
                if (frame != null) {
                    frame();
                }
            }
        }
    }

    // Graphics
    function loadSprite(graphics:String, width:Int=Config.CELL_SIZE, height:Int=Config.CELL_SIZE) {
        loadGraphic(graphics, true, width, height);
    }
    function addAnimation(name:String, row:Int, framesCount:Int, looped:Bool=true, frameRate=12, pickOne:Bool=false) {
        animation.add(
            name, 
            !pickOne ? [for (i in 0...framesCount) row*animationSheetWidth + i] : [row*animationSheetWidth + framesCount],
            frameRate,
            looped
        );
    }
    function addAnimationArray(name:String, row:Int, frames:Array<Int>, looped:Bool=true, frameRate=12) {
        animation.add(
            name, 
            [for (f in frames) row*animationSheetWidth + f],
            frameRate,
            looped
        );
    }
    public function playAnimation(name:String, ignorePriority:Bool=false) {
        if (animation.getByName(name) != null && animation.name != name) {
            // Check priority
            var needPriority = animationPriority.get(name);
            var curPriority = animationPriority.get(animation.name);
            if (needPriority != null && curPriority != null) {
                if (ignorePriority ? true : (needPriority[0] >= curPriority[0] ? needPriority[1]() : (animation.finished && needPriority[1]())))
                    animation.play(name);
            } else
                animation.play(name);
        }
    }
    
    // Misc
    public function getPosWithoutOffset():FlxPoint {
        return new FlxPoint(x - offset.x, y - offset.y);
    }
    function getAnimLength(?name:String):Int {
        var n = animation.name;
        if (name != null) n = name;

        var anim = animation.getByName(n);
        
        if (anim == null)
            return 0;
        else 
            return anim.frames.length; 
    }

    // Static
    public static inline function randomColor():Int {
        return FlxColor.fromHSL(FlxG.random.int(0, 360), 1, .5, 255);
    }
}
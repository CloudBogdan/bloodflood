package effects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using utils.Extensions.FlxTypedGroupExtensions;

class Trail extends FlxTypedGroup<FlxSprite> {
    // Settings
    public var graphic:String;
    public var graphicWidth:Int = 8;
    public var graphicHeight:Int = 8;
    public var graphicFrameIndex:Int = 0;
    
    public var position = new FlxPoint();
    public var isActive:Bool = true;
    public var lifeTime:Float = .4;
    public var spawnDelay:Float = .06;
    public var flipX:Bool = false;
    public var flipY:Bool = false;
    public var partAlpha:Float = 1;
    
    // Timers
    var spawnTimer = new FlxTimer();

    // Mics
    var spawned:Int = 0;
    
    public function new(Graphic:String, X:Float=0, Y:Float=0) {
        super();

        graphic = Graphic;
        position.x = X;
        position.y = Y;
    }
    
    public function start() {
        spawnTimer.start(spawnDelay);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (spawnTimer.finished) {
            this.removeDead();

            if (isActive)
                spawnParticle();
            
            spawnTimer.start(spawnDelay);
        }
    }

    function spawnParticle() {
        var part = new TrailPart(lifeTime, position.x, position.y);

        part.loadGraphic(graphic, true, graphicWidth, graphicHeight);
        part.flipX = flipX;
        part.flipY = flipY;
        part.animation.frameIndex = graphicFrameIndex;
        part.index = spawned;
        
        add(part);
        
        spawned ++;
    }
}

private class TrailPart extends FlxSprite {
    var time:Float = 0;
    var aliveTimer = new FlxTimer();
    public var index:Int = 0;
    
    public function new(LifeTime:Float, X:Float=0, Y:Float=0) {
        super(X, Y);

        aliveTimer.start(LifeTime);
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        time ++;

        color = FlxColor.fromHSL((Math.sin(time/2 + index/4) + 1)/2 * 360, 1, .5, 255);

        if (aliveTimer.finished)
            kill();
    }
}
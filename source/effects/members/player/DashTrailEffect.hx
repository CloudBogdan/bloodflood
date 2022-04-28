package effects.members.player;

import flixel.FlxSprite;
import objects.MySprite;

class DashTrailEffect extends Trail {
    public function new(X:Float, Y:Float) {
        super(AssetPaths.player__png, X, Y);

        isActive = false;
        partAlpha = .5;
        spawnDelay = .02;
        lifeTime = .16;

        start();
    }

    public function updateProps(target:FlxSprite, IsActive:Bool) {
        graphicFrameIndex = target.animation.frameIndex;
        flipX = target.flipX;
        position.x = target.x - target.offset.x;
        position.y = target.y - target.offset.y;
        isActive = IsActive;
    }
}
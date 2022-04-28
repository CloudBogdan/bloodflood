package effects.members;

class SwordSwipeEffect extends SpriteEffect {
    public function new(X:Float, Y:Float, FlipX:Bool, FlipY:Bool, crit:Bool) {
        super(X, Y);

        frameRate = 14;
        loadAnimation(AssetPaths.sword_swipe_effect__png, 5, 16, 16);
        animation.add("crit", [for (i in 0...5) 5 + i], 14, false);
        flipX = FlipX;
        flipY = FlipY;

        setup(X - width/2, Y - height/2, crit ? "crit" : SpriteEffect.NORMAL);
    }
}
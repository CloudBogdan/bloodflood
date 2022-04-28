package effects.members;

class DummySwordSwipeEffect extends SpriteEffect {
    public function new(X:Float, Y:Float, FlipX:Bool, FlipY:Bool) {
        super(X, Y);

        frameRate = 16;
        loadAnimation(AssetPaths.dummy_sword_swipe_effect__png, 5);
        flipX = FlipX;
        flipY = FlipY;

        setup(X - width/2, Y - height/2);
    }
}
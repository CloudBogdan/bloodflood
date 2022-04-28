package effects.members;

class JumpEffect extends SpriteEffect {
    public function new(X:Float, Y:Float) {
        super(X, Y);

        frameRate = 14;
        loadAnimation(AssetPaths.jump_effect__png, 4);

        setup(X - width/2, Y);
    }
}
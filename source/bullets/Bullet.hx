package bullets;

import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import objects.MySprite;

class Bullet extends MySprite {
    public var damage:Int = 1;
    var flySpeed:Float = 140;
    var direction:FlxVector = new FlxVector(1, 0);
    
    public function new(X:Float=0, Y:Float=0, ?Direction:FlxVector) {
        super(X, Y);

        // solid = true;
        if (Direction != null)
            direction.copyFrom(Direction);
    }
    
    override function update(elapsed:Float) {
        // Collide
        if (isTouching(ANY))
            explode();
        
        super.update(elapsed);

        var movement = new FlxVector(direction.x, direction.y);
        if (movement.x > .5)
            angle = 0;
        if (movement.x < -.5)
            angle = 180;
        if (movement.y > .5)
            angle = 90;
        if (movement.y < -.5)
            angle = -90;

        if (movement.x > .5 && movement.y > .5)
            angle = 45;
        if (movement.x < -.5 && movement.y > .5)
            angle = 45+90;
        if (movement.x > .5 && movement.y < -.5)
            angle = -45;
        if (movement.x < -.5 && movement.y < -.5)
            angle = -45-90;

        velocity.x = movement.x * flySpeed;
        velocity.y = movement.y * flySpeed;
    }

    public function explode(effect:Bool=true) {
        kill();
    }
}
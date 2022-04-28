package bullets;

import bullets.members.JustBullet;
import flixel.math.FlxVector;
import states.PlayState;

using utils.Extensions.FlxGroupExtensions;

class Bullets {
    public static function shootJustBullet(X:Float=0, Y:Float=0, ?Direction:FlxVector) {
        PlayState.bulletsGroup.removeDead();
        PlayState.bulletsGroup.add(new JustBullet(X, Y, Direction));
    }
}
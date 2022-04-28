package effects;

import effects.members.BloodEffect;
import effects.members.DummySwordSwipeEffect;
import effects.members.FootStepsEffect;
import effects.members.JumpEffect;
import effects.members.PoofEffect;
import effects.members.ShootEffect;
import effects.members.SparksEffect;
import effects.members.StarsEffect;
import effects.members.SwordSwipeEffect;
import flixel.math.FlxVector;
import states.PlayState;

using utils.Extensions.FlxGroupExtensions;

class Effects {

    public static function spawnJumpEffect(X:Float, Y:Float) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new JumpEffect(X, Y));
    }

    public static function spawnSwordSwipeEffect(X:Float, Y:Float, FlipX:Bool, FlipY:Bool, crit:Bool) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new SwordSwipeEffect(X, Y, FlipX, FlipY, crit));
    }
    public static function spawnDummySwordSwipeEffect(X:Float, Y:Float, FlipX:Bool, FlipY:Bool) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new DummySwordSwipeEffect(X, Y, FlipX, FlipY));
    }
    
    public static function spawnShootEffect(X:Float, Y:Float) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new ShootEffect(X, Y));
    }
    public static function spawnStarsEffect(X:Float, Y:Float) {
        PlayState.effectsGroup.removeDead();
        var ef = new StarsEffect(X, Y);
        ef.particlesCount = 4;
        PlayState.effectsGroup.add(ef);
        ef.start();
    }
    public static function spawnSparksEffect(X:Float, Y:Float, Count:Int, FlipX:Bool, Color:Int) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new SparksEffect(X, Y, Count, FlipX, Color));
    }
    public static function spawnFootStepsEffect(X:Float, Y:Float, FlipX:Bool) {
        PlayState.subEffectsGroup.removeDead();
        PlayState.subEffectsGroup.add(new FootStepsEffect(X, Y, FlipX));
    }
    public static function spawnBloodEffect(X:Float, Y:Float, count:Int, direction:FlxVector) {
        PlayState.subEffectsGroup.removeDead();
        PlayState.subEffectsGroup.add(new BloodEffect(X, Y, count, direction));
    }

    public static function spawnPoofEffect(X:Float, Y:Float, direction:FlxVector, force:Float=1) {
        PlayState.effectsGroup.removeDead();
        PlayState.effectsGroup.add(new PoofEffect(X, Y, direction, force));
    }
    
}


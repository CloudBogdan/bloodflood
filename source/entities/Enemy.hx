package entities;

import controls.StateMachine;
import effects.Effects;
import entities.Entity.EntityAnimation;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.PlayState;
import utils.Color;
import utils.Utils;

using utils.Extensions.FlxPointExtensions;

class Enemy extends Entity {
    // Static
    static var STUN_DURATION:Float = 1.8;
    
    // Is...
    var playerWasSeen:Bool = false;
    public var canTakeDamage:Bool = true;
    public var isStunned:Bool = false;
    public var isWallDetected:Bool = false;
    public var isFloorDetected:Bool = false;
    
    // Timers
    var stunTimer = new FlxTimer();
    
    // Mics
    public var stateMachine:StateMachine = new StateMachine();
    
    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);

        // Settings
        health = 50;
        maxJumps = 1;
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!alive)
            return;

        isStunned = stateMachine.currentState == STUN;
        canTakeDamage = !isStunned;
        
        checkWalls();
        checkFloor();
        checkPlayer();
    }

    function checkPlayer() {
        if (isStunned || !PlayState.player.alive) return;
        
        var playerPos = PlayState.player.getMidpoint();
        var thisPos = getMidpoint();
        var dir = new FlxVector(playerPos.x - thisPos.x, playerPos.y - thisPos.y);
        var rayHit = new FlxPoint();

        PlayState.tilemap.rayCast(thisPos, dir, rayHit);
        
        if (thisPos.squareDistance(playerPos) <= thisPos.squareDistance(rayHit) && Math.abs(playerPos.y - thisPos.y) < 20) {
            if (!playerWasSeen) {
                onPlayerWasSeen();
            }
            playerWasSeen = true;
        } else {
            if (playerWasSeen) {
                onPlayerHide();
            }
            // playerWasSeen = false;
        }
    }
    function checkWalls() {
        if (isStunned) return;
        
        var hit = new FlxPoint();
            
        PlayState.tilemap.rayCast(getMidpoint(), flipX ? new FlxPoint(-1, 0) : new FlxPoint(1, 0), hit);
        isWallDetected = getPosition().squareDistance(hit) < 6*6;
    }
    function checkFloor() {
        if (isStunned) return;
        
        var leftPos = new FlxPoint(
            getMidpoint().x - 8,
            getMidpoint().y
        );
        var rightPos = new FlxPoint(
            getMidpoint().x + 8,
            getMidpoint().y
        );
        
        var hitLeft = new FlxPoint();
        var hitRight = new FlxPoint();
            
        PlayState.tilemap.rayCast(leftPos, new FlxPoint(0, 1), hitLeft);
        PlayState.tilemap.rayCast(rightPos, new FlxPoint(0, 1), hitRight);

        isFloorDetected = leftPos.squareDistance(hitLeft) < 6*6 && rightPos.squareDistance(hitRight) < 6*6;
    }

    // On...
    function onPlayerWasSeen() {}
    function onPlayerHide() {}
    
    // Misc
    override function takeDamage(damage:Float, from:FlxPoint, crit:Bool=false) {
        hurt(damage);
        Effects.spawnBloodEffect(
            getMidpoint().x, getMidpoint().y, 0,
            new FlxVector(getMidpoint().x - from.x, getMidpoint().y - from.y).normalize()
        );
        
        if (crit)
            stateMachine.setState(STUN);
    }
    override function kill() {
        playAnimation(DEAD);
        FlxTween.color(
            this, 1,
            Color.WHITE, Color.GREY,
            { ease: FlxEase.linear, startDelay: 1 }
        );
        
        alive = false;
        exists = true;
    }
}

@:enum abstract EnemyAnimation(String) to String {
    var STUN = "stun";
}
@:enum abstract EnemyState(String) to String {
    var WALK = "walk";
    var ANGRY = "angry";
    var SURPRISED = "surprised";
    var STUN = "stun";
    var ATTACK = "attack";
}
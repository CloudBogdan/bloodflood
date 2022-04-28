package entities;

import effects.Effects;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import objects.MySprite;
import utils.Color;
import utils.Config;

class Entity extends MySprite {
    // Static
    static final COYOTE_DURATION:Float = .16;
    
    // Is...
    var isOnGround:Bool = false;
    var isMoving:Bool = false;
    public var isAttacking:Bool = false;
    public var wasInGrass:Bool = false;
    
    // Settings
    var moveSpeed:Float = 90;
    var jumpHeight:Float = 10;
    var maxJumps:Int = 1;
    
    // Movement
    var jumpsComplete:Int = 0;

    // Timers
    var time:Float = 0;
    var coyoteTimer = new FlxTimer();
    
    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);
    }
    
    function setup() {
        acceleration.y = Config.WORLD_GRAVITY;
        updateDrag();
        playAnimation(EntityAnimation.IDLE, true);
    }
    function setMoveSpeed(speed:Float) {
        moveSpeed = speed;
        updateDrag();
    }
    function updateDrag() {
        drag.x = moveSpeed * 10;
        maxVelocity.set(moveSpeed, 200);
    }
    
    override function update(elapsed:Float) {
        
        if (isTouching(DOWN)) {
            jumpsComplete = 0;
            if (!isOnGround)
                onGrounded();
            isOnGround = true;
        } else {
            if (!coyoteTimer.active && velocity.x != 0 && isOnGround)
                coyoteTimer.start(COYOTE_DURATION);
            isOnGround = false;
        }
        super.update(elapsed);
        time ++;
        
        //
        isMoving = velocity.x != 0;
        
        animate();
        effects();
    }

    // Movement
    public function move(direction:Float, autoFlip:Bool=true) {
        if (!alive)
            return;
        
        acceleration.x = direction * drag.x;

        if (autoFlip && velocity.x != 0 && direction != 0) {
            if (velocity.x < 0)
                flipX = true;
            else
                flipX = false;
        }
    }
    public function jump(?height:Float, ignoreIsNotOnGround:Bool=false, jumpEffect:Bool=true) {
        if (!((ignoreIsNotOnGround ? true : isOnGround) || jumpsComplete < maxJumps-1 || coyoteTimer.active))
            return; 

        var h = height != null ? height : jumpHeight; 
        
        y -= 1;
        velocity.y = -Math.sqrt(h * 2 * acceleration.y);
        playAnimation(JUMP);

        if (!isOnGround)
            jumpsComplete ++;
        if (jumpEffect)
            Effects.spawnJumpEffect(x + width/2, y + height);
    }
    public function flipAt(X:Float) {
        if (getMidpoint().x > X)
            flipX = true;
        else
            flipX = false;
    }

    // Mics
    function animate() {
        if (!alive)
            return;
        
        // Play walk and idle animation
        if (isMoving)
            playAnimation(WALK);
        else
            playAnimation(IDLE);

        // Play fall animation
        if (!isOnGround)
            playAnimation(FALL);
    }
    function effects() {
        // Foot steps effect
        if (isMoving && isOnGround && time % 16 == 0) {
            Effects.spawnFootStepsEffect(
                getMidpoint().x, y + height,
                !flipX
            );
        }
    }
    public function takeDamage(damage:Float, from:FlxPoint, crit:Bool=false) {
        hurt(damage);
    }
    public function pushFrom(from:FlxPoint) {
        var dir = (getMidpoint().x - from.x) / Math.abs(getMidpoint().x - from.x);
        
        acceleration.x = 0;
        velocity.x = 0;
        velocity.x += dir * 60;
    }

    // On...
    function onGrounded() {
        
    }
}
@:enum abstract EntityAnimation(String) to String {
    var IDLE = "idle";
    var WALK = "walk";
    var JUMP = "jump";
    var FALL = "fall";
    var ATTACK = "attack";
    var DEAD = "dead";
}
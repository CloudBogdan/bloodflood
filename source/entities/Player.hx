package entities;

import controls.Gamepad;
import effects.Effects;
import effects.members.StarsEffect;
import effects.members.player.DashTrailEffect;
import entities.Entity.EntityAnimation;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import items.swords.JustSword;
import states.PlayState;
import utils.Config;

using utils.Extensions.FlxPointExtensions;

class Player extends Entity {
    // Static
    static final DASH_DURATION:Float = .1;
    static final DASH_FORCE:Float = 460;
    static final DASH_COOLDOWN:Float = .3;
    static final IMMORTALITY_DURATION:Float = 1;

    // Timers
    var dashTimer = new FlxTimer();
    var dashImmortalityTimer = new FlxTimer();
    var dashCooldownTimer = new FlxTimer();
    var immortalityAfterDamageTimer = new FlxTimer();
    
    // Control
    var nextFlipState:Int = 0; // 0: nothing; 1: right; -1: left
    var dashDirection = new FlxVector();
    
    // Is...
    var isBreaking:Bool = false;
    var isAbortAttack:Bool = false;
    var isDashing:Bool = false;
    var isImmortality:Bool = false;
    var canDash:Bool = true;

    // Effects
    var dashTrail:DashTrailEffect;
    var dashStarsEffect:StarsEffect;

    // Items
    var sword:JustSword;
    
    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);

        // Settings setup
        health = 6;
        maxJumps = 2;
        
        // Animation setup
        animationSheetWidth = 7;
        loadSprite(AssetPaths.player__png);

        // Animation setting
        addAnimation(IDLE,    0, 1, false, 0);
        addAnimation(LOOK_UP, 0, 1, false, 0, true);
        addAnimation(WALK,    1, 5);
        addAnimation(JUMP,    3, 3, false, 14);
        addAnimation(FALL,    3, 2, false, 0, true);
        
        addAnimation(BREAKING, 2, 1, false, 0);
        addAnimation(DASH,     6, 4, false, 16);

        addAnimation(ATTACK_L,     4, 5, false, 24);
        addAnimation(ATTACK_R,     5, 5, false, 24);
        addAnimation(ATTACK_COMBO, 4, 7, false, 14);

        animationPriority = [
            WALK=>     [1, ()-> isMoving && isOnGround],
            IDLE=>     [1, ()-> !isMoving && isOnGround],
            LOOK_UP=>  [1, ()-> !isMoving && isOnGround],
            BREAKING=> [2, ()-> isBreaking],
            FALL=>     [3, ()-> !isOnGround],
            JUMP=>     [4, ()-> true],

            ATTACK_L=>     [5, ()-> true],
            ATTACK_R=>     [5, ()-> true],
            ATTACK_COMBO=> [5, ()-> true],

            DASH=> [6, ()-> isDashing],
        ];
                
        // Mics
        setSize(3, 6);
        offset.set(2, 2);
        
        // Effects
        // > Trails
        dashTrail = new DashTrailEffect(x, y);
        // > Emitters
        dashStarsEffect = new StarsEffect(x, y);
        dashStarsEffect.start(false, .01);

        PlayState.subEffectsGroup.add(dashStarsEffect);
        PlayState.subEffectsGroup.add(dashTrail);

        // Items
        sword = new JustSword(this);
        
        setup();
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        isBreaking = (Gamepad.horizontal() > 0 && flipX || Gamepad.horizontal() < 0 && !flipX) && isOnGround;
        isAttacking = animation.name.indexOf("attack") >= 0;
        isAbortAttack = isAttacking && animation.curAnim.curFrame >= 4;
        isDashing = dashTimer.active;
        isImmortality = isDashing || dashImmortalityTimer.active || immortalityAfterDamageTimer.active;
        
        if (!isDashing) {
            acceleration.y = Config.WORLD_GRAVITY;
        }

        sword.update();
        
        movement();
        attacking();
        dashing();
    }

    // Movement
    function movement() {
        if ((!isAttacking || isAbortAttack)) {
            if (!isDashing)
                move(Gamepad.horizontal());

            if (Gamepad.jump.triggered)
                jump();
        }
    }
    override function takeDamage(damage:Float, from:FlxPoint, crit:Bool=false) {
        if (!isImmortality && !isDashing) {
            hurt(damage);

            FlxG.camera.shake(.01, .1);
            immortalityAfterDamageTimer.start(IMMORTALITY_DURATION);
        }
    }
    
    // > Dash
    function dashing() {
        if (isOnGround && !isDashing && !dashCooldownTimer.active && !canDash) {
            canDash = true;
        }
        if (Gamepad.dash.triggered) {
            dash();
        }

        if (isDashing) {
            var dir = dashDirection;
            velocity.x = dir.x * DASH_FORCE;
            velocity.y = dir.y * DASH_FORCE;
        }

        dashTimer.onComplete = t-> {
            velocity.y *= .3;
            dashRecover();
        };
    }
    function dash() {
        if (!canDash)
            return;
        
        acceleration.set(0, 0);
        velocity.set(0, 0);
        
        dashDirection.copyFrom(lookDirection());

        saveFlipState();
        useFlipState();

        dashTimer.start(DASH_DURATION);
        dashImmortalityTimer.start(DASH_DURATION+.2);
        canDash = false;

        FlxG.camera.shake(.003, .1, null, true, dashDirection.x != 0 ? X : (dashDirection.y != 0 ? Y : XY));
        
        dashStarsEffect.acceleration.set(velocity.x/2, velocity.y/2);
        Effects.spawnPoofEffect(getMidpoint().x, getMidpoint().y, dashDirection);
    }
    function abortDash() {
        dashTimer.cancel();
        dashRecover();
    }
    function dashRecover() {
        if (!dashCooldownTimer.active) {
            dashCooldownTimer.start(DASH_COOLDOWN);
        }
    }
    
    function attacking() {
        if (Gamepad.attack.triggered)
            attack();
    }
    // > Attack
    function attack() {
        if (isAttacking)
            return;
        var hitted = sword.use();

        if (hitted) {
            FlxG.camera.shake(.002, .1, null, true, X);
        }

        saveFlipState();
        useFlipState();
    }
    function abortAttack() {
        if (isAbortAttack) {
            animation.stop();
        }
    }

    // Animation
    override function animate() {
        super.animate();
        
        if (isBreaking)
            playAnimation(BREAKING);
        if (isDashing)
            playAnimation(DASH);

        if (Gamepad.up.triggered)
            playAnimation(LOOK_UP);
    }
    override function effects() {
        super.effects();
        
        // Dash effects
        dashTrail.updateProps(this, (!canDash && (isDashing ? true : !isOnGround)) || (!isAbortAttack && isAttacking && sword.combo == 3));
        dashStarsEffect.updateProps(this, !canDash && (isDashing ? true : !isOnGround), isDashing);

        // Immortality effect
        if (immortalityAfterDamageTimer.active) {
            color = Math.floor(time / 2) % 2 == 0 ? 0xFF000000 : 0xFFFFFFFF;
        } else {
            color = 0xFFFFFFFF;
        }
    }

    // Mics
    function useFlipState() {
        if (nextFlipState == 1)
            flipX = false;
        else if (nextFlipState == -1)
            flipX = true;
    }
    function saveFlipState() {
        nextFlipState = Gamepad.horizontal();
    }
    function lookDirection():FlxVector {
        var dirX = Gamepad.horizontal();
        var dirY = Gamepad.vertical();
        if (dirX == 0 && dirY == 0) {
            dirX = flipX ? -1 : 1;
        }
        var direction = new FlxVector(dirX, dirY);
        direction.normalize();
        return direction;
    }
    
    // Override
    override function move(direction:Float, autoFlip:Bool=true) {
        super.move(direction, autoFlip);

        if (direction != 0)
            abortAttack();
    }
    override function jump(?height:Float, ignoreIsNotOnGround:Bool = false, jumpEffect:Bool = true) {
        if (height != 0) {
            abortAttack();
            abortDash();
        }
        
        super.jump(height, ignoreIsNotOnGround, jumpEffect);
    }
    override function kill() {
        super.kill();

        dashStarsEffect.kill();
        dashTrail.kill();
    }
}

@:enum abstract PlayerAnimation(String) to String {
    var LOOK_UP = "look-up";

    var BREAKING = "breaking";
    var DASH = "dash";
}
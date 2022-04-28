package entities.enemies;

import controls.Timeline;
import entities.Enemy.EnemyAnimation;
import entities.Enemy.EnemyState;
import entities.Entity.EntityAnimation;
import items.swords.DummySword;
import states.PlayState;
import utils.Config;
import utils.Utils;

using utils.Extensions.FlxPointExtensions;

class DummyEnemy extends Enemy {    
    // Static
    static var ANGRY_MOVE_SPEED:Float = 40;
    static var CALM_MOVE_SPEED:Float = 35;

    // Is...
    var floorDetected:Bool = false;

    // Items
    var sword:DummySword;
    
    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);

        // Settings
        health = 10;
        moveSpeed = CALM_MOVE_SPEED;

        // Animations
        animationSheetWidth = 5;
        loadSprite(AssetPaths.dummy_enemy__png);

        addAnimation(IDLE, 0, 1, false, 0);
        addAnimation(WALK, 1, 5);
        addAnimation(JUMP, 2, 3, false, 14);
        addAnimation(FALL, 2, 2, false, 0, true);
        addAnimation(STUN, 3, 1, false, 0);
        addAnimationArray(ATTACK_DOWN, 4, [0,1,0,1,0, 2, 3, 4], false, 6);
        addAnimation(DEAD, 5, 3, false, 8);

        animationPriority = [
            WALK=> [1, ()-> isMoving && isOnGround],
            IDLE=> [1, ()-> !isMoving && isOnGround],
            FALL=> [3, ()-> !isOnGround],
            JUMP=> [4, ()-> true],
            ATTACK_DOWN=> [5, ()-> !isStunned],
            STUN=> [6, ()-> isStunned],
            DEAD=> [7, ()-> true]
        ];
        animationTimeline = [
            // Attack with sword in 5 frame of ATTACK_DOWN animation
            ATTACK_DOWN=> [ 5=> ()-> sword.use() ]
        ];

        setSize(3, 6);
        offset.set(2, 2);
        origin.set(3.5, 5);
        
        // State machine
        stateMachine.states = [
            WALK=> 1,
            ANGRY=> 2,
            ATTACK=> 3,
            SURPRISED=> 4,
            STUN=> 5,
        ];

        stateMachine.onChange = state-> {
            
            switch (state) {
                case SURPRISED:
                    Timeline.timeline(
                        [.1, ()-> flipAt(PlayState.player.getMidpoint().x)],
                        [.2, ()-> jump(2)],
                        [.4, ()-> stateMachine.setState(ANGRY, true)]
                    );
                case STUN:
                    stunTimer.start(Enemy.STUN_DURATION);
                case ATTACK:
                    flipAt(PlayState.player.getMidpoint().x);
                    playAnimation(ATTACK_DOWN);
            }
        };
        stateMachine.currentState = WALK;
        stateMachine.onChange(WALK);

        // Items
        sword = new DummySword(this);
        
        setup();
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);
        
        acceleration.y = Config.WORLD_GRAVITY;
        
        if (!alive) {
            // playAnimation(DEAD);
            return;
        }
        
        if (isWallDetected)
            flipX = !flipX;
        if (!isFloorDetected) {
            if (floorDetected) {
                flipX = !flipX;
                floorDetected = false;
            }
        } else {
            floorDetected = true;
        }

        stunTimer.onComplete = t-> {
            stateMachine.setState(ANGRY, true);
        }

        movement();
    }

    // Movement
    function movement() {
        if (!PlayState.player.alive)
            stateMachine.setState(WALK, true);
        
        switch (stateMachine.currentState) {
            case WALK:
                setMoveSpeed(CALM_MOVE_SPEED);
                move(flipX ? -1 : 1, false);
            case ANGRY:
                if (playerWasSeen) {
                    setMoveSpeed(ANGRY_MOVE_SPEED);
                    move(flipX ? -1 : 1, false);

                    if (getMidpoint().squareDistance(PlayState.player.getMidpoint()) < 12*12) {
                        stateMachine.setState(ATTACK);
                    }
                    
                } else {
                    stateMachine.setState(WALK, true);
                }
                
            case STUN:
                playAnimation(STUN);
                move(0, false);
            case SURPRISED:
                move(0, false);
                
            case ATTACK:
                if (animation.finished)
                    stateMachine.setState(ANGRY, true);
                move(0, false);
                
        }
    }

    // On...
    override function onPlayerWasSeen() {
        super.onPlayerWasSeen();

        stateMachine.setState(SURPRISED);
    }
    override function onPlayerHide() {
        super.onPlayerHide();
    }
}
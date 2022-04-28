package controls;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import utils.Utils;

class Gamepad {
    static var actionsManager:FlxActionManager;
    public static var right:FlxActionDigital;
    public static var left:FlxActionDigital;
    public static var up:FlxActionDigital;
    public static var down:FlxActionDigital;
    public static var jump:FlxActionDigital;
    public static var attack:FlxActionDigital;
    public static var shoot:FlxActionDigital;
    public static var dash:FlxActionDigital;
    
    public function new() {
        right = new FlxActionDigital("right")
            .addKey(RIGHT, PRESSED)
            .addKey(D, PRESSED);
        left = new FlxActionDigital("left")
            .addKey(LEFT, PRESSED)
            .addKey(A, PRESSED);
        up = new FlxActionDigital("up")
            .addKey(UP, PRESSED)
            .addKey(W, PRESSED);
        down = new FlxActionDigital("down")
            .addKey(DOWN, PRESSED)
            .addKey(S, PRESSED);
        jump = new FlxActionDigital("jump")
            .addKey(SPACE, JUST_PRESSED);
        attack = new FlxActionDigital("attack")
            .addKey(K, JUST_PRESSED)
            .addKey(X, JUST_PRESSED)
            .addMouse(LEFT, JUST_PRESSED);
        shoot = new FlxActionDigital("shoot")
            .addKey(L, PRESSED)
            .addKey(Z, PRESSED)
            .addMouse(RIGHT, PRESSED);
        dash = new FlxActionDigital("dash")
            .addKey(SHIFT, JUST_PRESSED);

        if (actionsManager == null)
            actionsManager = FlxG.inputs.add(new FlxActionManager());
        actionsManager.addActions([
            right, left, up, down, jump, attack, shoot, dash
        ]);
            
    }

    public static function horizontal():Int {
        return Utils.boolToInt(right.triggered) - Utils.boolToInt(left.triggered);
    }
    public static function vertical():Int {
        return Utils.boolToInt(down.triggered) - Utils.boolToInt(up.triggered);
    }
}
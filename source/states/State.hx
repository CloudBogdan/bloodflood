package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import utils.Color;

class State extends FlxState {
    public var background:FlxSprite;
    
    override function create() {
        super.create();

        background = new FlxSprite();
        background.immovable = true;
        background.allowCollisions = NONE;
        background.scrollFactor.set(0, 0);
        background.makeGraphic(FlxG.width, FlxG.height, Color.BLACK);
    }

    function addBackground() {
        add(background);
    }
}
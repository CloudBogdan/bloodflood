package states;

import bullets.Bullet;
import bullets.members.JustBullet;
import controls.Gamepad;
import effects.Emitter;
import entities.Enemy;
import entities.Entity;
import entities.Player;
import entities.enemies.DummyEnemy;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.tile.FlxRayCastTilemap;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import utils.Color;
import utils.Types;

class PlayState extends State
{
	// Objects
	public static var player:Player;
	public static var tilemap:FlxRayCastTilemap;
	var map:FlxOgmo3Loader;

	// Groups
	public static var entitiesGroup:FlxTypedGroup<Entity>;
	public static var bulletsGroup:FlxGroup;
	public static var collidersGroup:FlxGroup;

	public static var floraGroup:FlxGroup;
	public static var effectsGroup:FlxGroup;
	public static var subEffectsGroup:FlxGroup;
	
	override public function create()
	{
		super.create();

		// Controls init
		new Gamepad();

		// Groups init
		entitiesGroup = new FlxTypedGroup();
		// enemiesGroup = new FlxTypedGroup();
		bulletsGroup = new FlxGroup();
		collidersGroup = new FlxGroup();

		effectsGroup = new FlxGroup();
		subEffectsGroup = new FlxGroup();
		floraGroup = new FlxGroup();
		// Objects init
		player = new Player(30, 70);
		tilemap = new FlxRayCastTilemap();
		generateMap();

		addBackground();
		add(subEffectsGroup);
		add(floraGroup);

		add(entitiesGroup);
		
		add(tilemap);
		add(bulletsGroup);
		add(effectsGroup);
		add(collidersGroup);
		
		entitiesGroup.add(player);

		// Snow
		var snowEmitter = new Emitter(-FlxG.width/2, 0, 100);

		snowEmitter.particleFrames = ()-> [4];
		snowEmitter.lifespan.set(2, 3);
		snowEmitter.setSize(FlxG.width*2, 1);
		snowEmitter.velocity.set(
			10, 80,
			40, 100
		);
		
		snowEmitter.createParticles();
		snowEmitter.start(false, .06);
		effectsGroup.add(snowEmitter);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Add dummy
		if (FlxG.mouse.justPressedMiddle) {
			entitiesGroup.add(new DummyEnemy(FlxG.mouse.getPosition().x, FlxG.mouse.getPosition().y));
		}

		entitiesGroup.sort((i, a, b)-> {
			if (a is Player)
				return 1;
			return 0;
		}, FlxSort.DESCENDING);
		
		FlxG.collide(entitiesGroup, tilemap);
		FlxG.collide(bulletsGroup, tilemap);

		FlxG.overlap(bulletsGroup, entitiesGroup, (blt:Bullet, ent:Entity)-> {
			if (blt is JustBullet && ent is Enemy) {
				blt.explode(false);
				ent.hurt(blt.damage);
			}
		});
	}

	function generateMap() {
		tilemap.setCustomTileMappings([], [2, 31], [[2,2,2, 3, 4], [31,31,31, 32, 33]]);

		map = new FlxOgmo3Loader(AssetPaths.maps__ogmo, AssetPaths.test_map__json);
		map.loadTilemap(AssetPaths.snow_tiles__png, "tiles", tilemap);
		map.loadEntities(placeEntities);

		tilemap.setPosition(-8, 0);
		
		for (tile in tilemap.getTileCoords(2, false)) {
			if (FlxG.random.bool(50))
				floraGroup.add(new GrassPart(tile.x, tile.y-8));
		}
	}
	function placeEntities(entity:EntityData) {
		var x = entity.x;
		var y = entity.y;
		
		switch (entity.name) {
			case "player":
				player.setPosition(x, y);
			case "dummy-enemy":
				entitiesGroup.add(new DummyEnemy(x, y));
		}
	}
}

class GrassPart extends FlxSprite {
	public function new(X:Float, Y:Float) {
		super(X, Y);

		loadGraphic(AssetPaths.grass__png, true, 8, 8);
		allowCollisions = NONE;

		flipX = FlxG.random.bool(50);
		color = FlxG.random.bool(80) ? Color.GREEN : Color.SNOW_WHITE;
		animation.frameIndex = FlxG.random.int(0, 3);
	}
}
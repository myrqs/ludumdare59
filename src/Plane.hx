package;

import ceramic.SpriteSheet;
import ceramic.Sprite;

class Plane extends Sprite {
	public var hitSize:Float = 300;
	public function new() {
		super();
		anchor(0.5, 0.5);
		scale(2.5);
        rotation = 90;
		this.x = x;
		this.y = y;
		sheet = new SpriteSheet();
		sheet.texture = app.scenes.main.assets.texture(Images.DANGER_PLANE_SEQUENCE_TEST);
		sheet.grid(166, 167);
		sheet.addGridAnimation('idle', [0], 0);
		sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 0.1);
		animation = 'flying';
	}
}

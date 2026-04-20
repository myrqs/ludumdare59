package;

import ceramic.Graphics;
import ceramic.Color;
import ceramic.SpriteSheet;
import ceramic.Sprite;

class Goal extends Sprite { // pos, graphics
	var graphics:Graphics;
    var color:Color;
	var itime:Float;

	public function draw() {
	}

	override function update(delta:Float) {
		super.update(delta);
		itime += delta;
		graphics.lineStyle(50, Color.YELLOW);
		graphics.drawArc(x, y, 20, 0, 360);
		scaleX += Math.sin(itime) * 0.00025;
		scaleY += Math.sin(itime) * 0.00025;

	}
	public function new(x:Int, y:Int, color:Color, graphics:Graphics) {
		super();
        this.color = color;
        this.x =x;
        this.y =y;
        this.graphics = graphics;
		scale(0.25,0.25);
        anchor(0.5,0.5);
		sheet = new SpriteSheet();
		sheet.texture = app.scenes.main.assets.texture(Images.MAP__HEALSTATION_LAKE);
		sheet.grid(1326, 1156);
		sheet.addGridAnimation('idle', [0], 0);
		animation = 'idle';
    }

}


package;

import ceramic.Color;
import ceramic.Graphics;
import ceramic.Point;
import ceramic.SpriteSheet;
import ceramic.Sprite;

class Enemy extends Sprite {
	var speed = 50;
	var amplitude = 40;
	var frequency = 2;
	var birdtime = 0.0;

    var turnRate = 3.0;
	var dirX = 1.0;
	var dirY = 0.0;
	var target:Point = Point.get(0, 0);
    var graphics:Graphics;

	public function new(x:Float, y:Float, graphics:Graphics) {
		super();
        scale(0.2,0.2);
        anchor(0.5,0.5);
		this.x = x;
		this.y = y;
        this.graphics = graphics;
		sheet = new SpriteSheet();
		sheet.texture = app.scenes.main.assets.texture(Images.ENEMY_GOSHAWK_SEQUENCE);
		sheet.grid(666, 667);
		sheet.addGridAnimation('idle', [0], 0);
		sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6], 0.1);
		animation = 'flying';
		log.debug('placed Enemy at: ' + x + ':' + y);
	}

	override function update(delta:Float) {
        super.update(delta);
		birdtime += delta;
        
        graphics.lineStyle(2, Color.BLACK);
        graphics.drawCircle(target.x, target.y, 5);
        graphics.drawCircle(x, y, 5);
        graphics.drawLine(x, y, target.x, target.y);

		var toTargetX = target.x - x;
		var toTargetY = target.y - y;

		var len = Math.sqrt(toTargetX * toTargetX + toTargetY * toTargetY);
		if (len > 0) {
			toTargetX /= len;
			toTargetY /= len;
		}

		dirX += (toTargetX - dirX) * turnRate * delta;
		dirY += (toTargetY - dirY) * turnRate * delta;

		var dirLen = Math.sqrt(dirX * dirX + dirY * dirY);
		if (dirLen > 0) {
			dirX /= dirLen;
			dirY /= dirLen;
		}

		var perpX = -dirY;
		var perpY = dirX;

		var sway = Math.sin(birdtime * frequency) * amplitude;

		x += (dirX * speed + perpX * sway) * delta;
		y += (dirY * speed + perpY * sway) * delta;

		rotation = (Math.atan2(dirY, dirX) + Math.PI / 2) * 180 / Math.PI;
	}

	public function setTarget(target:Point) {
        this.target = target;
	}
}

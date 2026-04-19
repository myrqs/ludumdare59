package;

import ceramic.GeometryUtils;
import ceramic.Point;
import ceramic.SpriteSheet;
import ceramic.Sprite;

class Bird extends Sprite{

    var speed = 50;
	var amplitude = 40;
	var frequency = 2;
	var birdtime = 0.0;

    var turnRate = 3.0;
	var dirX = 0.0;
	var dirY = 0.0;
	var target:Point = Point.get(0, 0);
	public var following:Bool = false;
	var targetEnemy:Enemy;

    public function new(x:Float, y:Float) {
        super();
        anchor(0.5, 0.5);
        scale(0.1);
        this.x = x;
        this.y = y;
        sheet = new SpriteSheet();
        sheet.texture = app.scenes.main.assets.texture(Images.ZUGVOGEL_SPRITE_NPC_ABLAUF__ABL_UFE_GESAMT);
        sheet.grid(666, 667);
        sheet.addGridAnimation('idle', [0], 0);
        sheet.addGridAnimation('flying', [0,1,2,3,4,5,6], 0.1);
        animation = 'flying';
        log.debug('placed Bird at: ' + x + ':' + y);
    }

    override function update(delta:Float) {
        super.update(delta);
		if(targetEnemy != null){
		 	target = Point.get(targetEnemy.x, targetEnemy.y);
			if(GeometryUtils.pointInRectangle(x, y, targetEnemy.x, targetEnemy.y, targetEnemy.width * targetEnemy.scaleX, targetEnemy.height * targetEnemy.scaleY)){

				targetEnemy.destroy();
				destroy();
			}
		}
        birdtime += delta;

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

	public function setMovingTarget(target:Enemy) {
		this.targetEnemy = target;
		this.speed = 100;
	}
}
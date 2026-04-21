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
	public var score:Int = 5;

    public function new(x:Float, y:Float) {
        super();
        anchor(0.5, 0.5);
        this.x = x;
        this.y = y;
		this.depth = 10;
		this.birdtime = Std.random(10) * 0.1;
		this.amplitude = Std.random(20) + 20;
    }

    override function update(delta:Float) {
        super.update(delta);
		if(targetEnemy != null){
		 	target = Point.get(targetEnemy.x, targetEnemy.y);
			if(GeometryUtils.pointInRectangle(x, y, targetEnemy.x, targetEnemy.y, targetEnemy.width * targetEnemy.scaleX, targetEnemy.height * targetEnemy.scaleY)){

				
				targetEnemy.tween(ELASTIC_EASE_OUT, 2, targetEnemy.scaleX, 0.00001, function(value, time) {
					targetEnemy.scale(value);
				}).onceComplete(this, function() {
					app.scenes.main.assets.sound(Sounds.SOUNDS__ENEMY_BIRD_DEATH).play();
					var main = cast(app.scenes.main, MainScene);
					main.enemies.remove(targetEnemy);
					targetEnemy.destroy();
					//add explosion graphics
				
					main.npcs.remove(this);
					main.player.xp += 10 + cast(app.scenes.main, MainScene).currentLevel;
					main.player.score += 1 + cast(app.scenes.main, MainScene).currentLevel;
					destroy();
					
				});
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
		this.following = false;
	}
}
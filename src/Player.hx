package;

import ceramic.Sprite;
import ceramic.Graphics;
import ceramic.Point;

class Player {
	var target:Point = Point.get(0,0);
    public var logo:Sprite;
    var graphics:Graphics;
    var birds:Array<Bird> = new Array<Bird>();
    var vShapeLeft:Point = Point.get(0,0);
    var vShapeRight:Point = Point.get(0,0);
    var vShapeSetUp:Bool = false;
    public var hitpoints:Int = 100;
    public var speed:Float = 50.0;
    public var stamina:Float = 100;
    public var score:Int = 0;
    public var xp:Int = 0;

    public function new(graphics:Graphics, logo:Sprite) {
        this.graphics = graphics;
        this.logo = logo;
    }

	public function draw(delta:Float) {
		if (target.x != 0 || target.y != 0) {
			var xdir = target.x - logo.x;
			var ydir = target.y - logo.y;
			var distance = Math.sqrt(xdir * xdir + ydir * ydir);

			if (distance > 0) {
				logo.rotation = (Math.atan2(ydir, xdir) + Math.PI / 2) * 180 / Math.PI;

				var nx = xdir / distance;
				var ny = ydir / distance;

				var movex = nx * speed * delta; //test
				var movey = ny * speed * delta;

				logo.pos(logo.x + movex, logo.y + movey);
			}
		}
        drawTriangle();
	}

    function drawTriangle() {
        var topX = logo.x;
        var topY = logo.y;

        var rotation = logo.rotation * Math.PI / 180;

        rotation -= Math.PI / 2;

        var length = 500;
        var spread = Math.PI / 3;

        vShapeLeft.x = topX + Math.cos(rotation + Math.PI + spread) * length;
        vShapeLeft.y = topY + Math.sin(rotation + Math.PI + spread) * length;

        vShapeRight.x = topX + Math.cos(rotation + Math.PI - spread) * length;
        vShapeRight.y = topY + Math.sin(rotation + Math.PI - spread) * length;

        var index = 0;
        for(bird in birds){
            var pnt = Point.get(topX + Math.cos(rotation + Math.PI + spread) * (length/(index+1)), topY + Math.sin(rotation + Math.PI + spread) * (length/(index+1)));

            if(index % 2 == 0){
                pnt = Point.get(topX + Math.cos(rotation + Math.PI - spread) * (length/((index-1)+1)), topY + Math.sin(rotation + Math.PI - spread) * (length/((index-1)+1)));
            }
            bird.setTarget(pnt);
            index++;
        }

        //graphics.drawLine(topX, topY, vShapeLeft.x, vShapeLeft.y);
        //graphics.drawLine(topX, topY, vShapeRight.x, vShapeRight.y);
        vShapeSetUp = true;
    }

    public function addBird(bird:Bird) {
        birds.push(bird);
    }

    public function shootBird(target:Enemy) {
        if(birds.length > 0){
            var bird = Lambda.filter(birds, x -> Std.isOfType(x, JourneyBird)).pop();
            if(bird != null){
                bird.setMovingTarget(target);
                birds.remove(bird);
                app.scenes.main.assets.sound(Sounds.SOUNDS__BIRD_SHOOTING).play();
            }
        }
    }

    public function attack():Array<Projectile> {
        var tmp = new Array<Projectile>();
        if(birds.length > 0){
            var seagulls = Lambda.filter(birds, x -> Std.isOfType(x, Seagull));
            for(seagull in seagulls){
                tmp.push(cast(seagull, Seagull).attack());
                app.scenes.main.assets.sound(Sounds.SOUNDS__POOPATTACK).play();
            }
            return tmp;
        }
        return null;
    }

    public function jam() {
        if(birds.length > 0){
            var pigeons = Lambda.filter(birds, x -> Std.isOfType(x, Pigeon));
            for(pigeon in pigeons){
                cast(pigeon, Pigeon).jam();
            }
        }
    }

    public function setTarget(target:Point) {
        this.target = target;
    }
    public function wincondition(target:Goal) {
        if(birds.length>0 ){
            var bird = birds.pop();
            bird.setTarget (Point.get(target.x, target.y ));
            score += bird.score;
        }
    }

    public function radarconfusion(target:WaveSource) {
        if(birds.length>0 ){
            var bird = birds.pop();
            bird.setTarget (Point.get(target.x, target.y ));
        }
    }

    public function checkForBird<T>(type: Class<T>):Bool {
        return Lambda.exists(birds, x -> Std.isOfType(x, type));
    }
}
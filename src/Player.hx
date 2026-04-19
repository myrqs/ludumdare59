package;

import ceramic.Sprite;
import ceramic.Graphics;
import ceramic.Point;

class Player {
	var target:Point = Point.get(0,0);
    var logo:Sprite;
    var graphics:Graphics;
    var birds:Array<Bird> = new Array<Bird>();
    var vShapeLeft:Point = Point.get(0,0);
    var vShapeRight:Point = Point.get(0,0);
    var vShapeSetUp:Bool = false;
    public var hitpoints:Int = 100;

    public function new(graphics:Graphics, logo:Sprite) {
        this.graphics = graphics;
        this.logo = logo;
    }

	public function draw(delta:Float) {
		if (target.x != 0 || target.y != 0) {
			var xdir = target.x - logo.x;
			var ydir = target.y - logo.y;
			log.debug('xdir: ' + xdir + 'ydir: ' + ydir);
			var distance = Math.sqrt(xdir * xdir + ydir * ydir);

			if (distance > 0) {
				logo.rotation = (Math.atan2(ydir, xdir) + Math.PI / 2) * 180 / Math.PI;

				var nx = xdir / distance;
				var ny = ydir / distance;

				var movex = nx * 50.0 * delta; //test
				var movey = ny * 50.0 * delta;

				logo.pos(logo.x + movex, logo.y + movey);
			}
		}
        for(bird in birds){
            bird.update(delta);
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

        for(bird in birds){
            bird.pos(topX + Math.cos(rotation + Math.PI + spread) * length/3, topY + Math.sin(rotation + Math.PI + spread) * length/3);
            bird.rotation = logo.rotation;
            bird.animation = logo.animation;
        }

        graphics.drawLine(topX, topY, vShapeLeft.x, vShapeLeft.y);
        graphics.drawLine(topX, topY, vShapeRight.x, vShapeRight.y);
        vShapeSetUp = true;
        if(vShapeSetUp && birds.length == 0){
            var bird:Bird = new Bird(topX + Math.cos(rotation + Math.PI + spread) * length/3, topY + Math.sin(rotation + Math.PI + spread) * length/3);
            birds.push(bird);
            bird.anchor(0.5, 0.5);
            bird.scale(0.1);
            bird.alpha = 1;
            app.scenes.main.add(bird);

        }
    }

    public function setTarget(target:Point) {
        this.target = target;
    }
}

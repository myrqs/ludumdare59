package;

import ceramic.Quad;
import ceramic.Graphics;
import ceramic.Point;

class Player {
	var target:Point = Point.get(0,0);
    var logo:Quad;
    var graphics:Graphics;

    public function new(graphics:Graphics, logo:Quad) {
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

				var movex = nx * 50.0 * delta;
				var movey = ny * 50.0 * delta;

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

        var leftX = topX + Math.cos(rotation + Math.PI + spread) * length;
        var leftY = topY + Math.sin(rotation + Math.PI + spread) * length;

        var rightX = topX + Math.cos(rotation + Math.PI - spread) * length;
        var rightY = topY + Math.sin(rotation + Math.PI - spread) * length;

        graphics.drawLine(topX, topY, leftX, leftY);
        graphics.drawLine(topX, topY, rightX, rightY);
    }

    public function setTarget(target:Point) {
        this.target = target;
    }
}

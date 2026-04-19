package;

import ceramic.Graphics;
import ceramic.Color;

class Healingstation { // pos, graphics
	public var x:Int = 0;
	public var y:Int = 0;

	var graphics:Graphics;
    var color:Color;

	public function draw() {
		graphics.lineStyle(50, Color.GREEN);
		graphics.drawArc(x, y, 20, 0, 360);
	}

	public function new(x:Int, y:Int, color:Color, graphics:Graphics) {
        this.color = color;
        this.x =x;
        this.y =y;
        this.graphics = graphics;
    }

}


package;

import ceramic.Graphics;
import ceramic.Color;

class Wave {
    var itime:Float = 0.0;
    var x: Int = 0;
    var y: Int = 0;
    var color: Color = Color.YELLOW;
    var graphics:Graphics;

    public function draw(delta: Float) {
        graphics.lineStyle(2, Color.fromRGB(255, 200, 50));
        graphics.drawArc(200, 400, 10 * itime, 0, 360);
        itime += delta;
    }
    public function new(x: Int, y:Int, color:Color, graphics:Graphics) {
        this.color = color;
        this.x = x;
        this.y = y;
        this.graphics = graphics;
    }
}
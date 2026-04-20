package;

import ceramic.Color;
import ceramic.Quad;

class Projectile extends Quad {
    var dirX = 0;
    var dirY = 0;
    var startrot: Float;
    public function new(x:Float, y:Float, dirX:Int, dirY:Int, rotation:Float) {
        super();
        this.x = x;
        this.y = y;
        this.dirX = -dirX;
        this.dirY = -dirY;
        this.width = 10;
        this.height = 10;
        this.rotation = rotation;
        this.color = Color.WHITE;
        this.depth = 10;
    }

    public function update(delta:Float) {
        x += dirX;
        y += dirY;
    }
}
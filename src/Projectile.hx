package;

import ceramic.Color;
import ceramic.Quad;

class Projectile extends Quad {
    var dirX = 0;
    var dirY = 0;
    public function new(dirX:Int, dirY:Int, rotation:Float) {
        super();
        this.dirX = dirX;
        this.dirY = dirY;
        this.width = 10;
        this.height = 10;
        this.rotation = rotation;
        this.color = Color.WHITE;
    }

    public function update(delta:Float) {
        x += dirX;
        y += dirY;    
    }
}
package;

import ceramic.Graphics;
import ceramic.Color;

class WaveSource {
    public var x: Int = 0;
    public var y: Int = 0;
    var color: Color = Color.YELLOW;
    var graphics:Graphics;
    var timer:Int = 0;
    public var waves:Array<Wave> = new Array<Wave>();
    
    public function draw(delta: Float){
        
        for(i in waves){
            i.draw(delta);
        }
        timer += 1;
        if(timer >= 100){
            waves.push(new Wave(x, y, color, graphics));
            timer = 0;
        }

        if(waves.length >= 15){
            waves.shift();
        }
        
    }

    public function new(x: Int, y:Int, color:Color, graphics:Graphics) {
        this.color = color;
        this.x = x;
        this.y = y;
        this.graphics = graphics;
        waves.push(new Wave(x, y, color, graphics));
    }

}
package;

import ceramic.Graphics;
import ceramic.Color;
import ceramic.SpriteSheet;
import ceramic.Sprite;

class WaveSource extends Sprite {
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
            waves.push(new Wave(Math.floor(x), Math.floor(y), color, graphics));
            timer = 0;
            //app.scenes.main.assets.sound(Sounds.SOUNDS__SOUND_DEFAULT).play();
        }

        if(waves.length >= 15){
            waves.shift();
        }
        
    }

    public function new(x: Int, y:Int, color:Color, graphics:Graphics) {
        super();
		anchor(0.5, 0.5);
        scale(3.0);
		sheet = new SpriteSheet();
		sheet.texture = app.scenes.main.assets.texture(Images.ASSET_RADAR_DISH_SEQUENCE);
		sheet.grid(59, 41);
		sheet.addGridAnimation('idle', [0, 1, 2, 3, 4, 5, 6, 7, 8], 0.1);
		animation = 'idle';
        this.color = color;
        this.x = x;
        this.y = y;
        this.graphics = graphics;
        waves.push(new Wave(x, y, color, graphics));
    }

}
package;

import ceramic.SpriteSheet;
import ceramic.Sprite;

class Cloud extends Sprite {
    public function new(x:Int, y:Int) {
        super();
        scale(Std.random(8) + 4);
        this.x = x;
		this.y = y;
		sheet = new SpriteSheet();
		sheet.grid(33, 33);
        var chance = Std.random(100);
        if(chance < 30){
            sheet.texture = app.scenes.main.assets.texture(Images.MAP__CLOUD_SEQUENCE_1);
		    sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 0.1);
        }else if(chance < 80){
            sheet.texture = app.scenes.main.assets.texture(Images.MAP__CLOUD_SEQUENCE_2);
		    sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 0.1);
        } else {
            sheet.texture = app.scenes.main.assets.texture(Images.MAP__CLOUD_SEQUENCE_3);
            sheet.grid(64, 33);
		    sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 0.1);
        }
		animation = 'flying';
    }
}
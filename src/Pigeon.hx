package;

import ceramic.SpriteSheet;

class Pigeon extends Bird {
    public function new(x:Float, y:Float) {
        super(x, y);
        scale(2.0);
        sheet = new SpriteSheet();
        sheet.texture = app.scenes.main.assets.texture(Images.ALLY_PIGEON_SEQUENCE);
        sheet.grid(33, 33);
        sheet.addGridAnimation('idle', [0], 0);
        sheet.addGridAnimation('flying', [0,1,2,3,4,5,6], 0.1);
        animation = 'flying';
        this.score = 50;
        log.debug('placed Bird at: ' + x + ':' + y);
    }
}
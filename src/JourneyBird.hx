package;

import ceramic.SpriteSheet;

class JourneyBird extends Bird {
    public function new(x:Float, y:Float) {
        super(x, y);
        scale(0.1);
        sheet = new SpriteSheet();
        sheet.texture = app.scenes.main.assets.texture(Images.ZUGVOGEL_SPRITE_NPC_ABLAUF__ABL_UFE_GESAMT);
        sheet.grid(666, 667);
        sheet.addGridAnimation('idle', [0], 0);
        sheet.addGridAnimation('flying', [0,1,2,3,4,5,6], 0.1);
        animation = 'flying';
        this.score = 10;
        log.debug('placed Bird at: ' + x + ':' + y);
    }
}
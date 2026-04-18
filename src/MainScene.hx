package;

import ceramic.Color;
import ceramic.Graphics;
import ceramic.Point;
import ceramic.TouchInfo;
import ceramic.Quad;
import ceramic.Scene;

class MainScene extends Scene {

    var logo:Quad;
    var target:Point = Point.get(0,0);
    var graphics:Graphics;
    var time:Float = 0;
    var waveSources:Array<WaveSource> = new Array<WaveSource>();
    var timer:Int = 0;
    var player:Player;

    override function preload() {
        assets.add(Images.CERAMIC);
        assets.add(Images.ZUGVOGEL_SPRITE_ANF_HRER);
    }

    override function create() {

        logo = new Quad();
        logo.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER);
        logo.anchor(0.5, 0.5);
        logo.pos(width * 0.5, height * 0.5);
        logo.scale(0.0001);
        logo.alpha = 0;
        add(logo);

        logo.tween(ELASTIC_EASE_IN_OUT, 0.75, 0.0001, 1.0, function(value, time) {
            logo.alpha = value;
            logo.scale(value);
        });


        graphics = new Graphics();
        graphics.pos(0, 0);
        add(graphics);

        player = new Player(graphics, logo);

        this.onPointerDown(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            player.setTarget(Point.get(info.x, info.y));
            screen.onPointerMove(this, moveTo);
        });

        this.onPointerUp(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            player.setTarget(Point.get(0, 0));
            screen.offPointerMove(moveTo);
        });

        waveSources.push(new WaveSource(200, 400, Color.YELLOW, graphics));
        waveSources.push(new WaveSource(100, 100, Color.RED, graphics));
    }

    function moveTo(info:TouchInfo) {
        player.setTarget(Point.get(info.x, info.y));
    }

    override function update(delta:Float) {
        time += delta;
        graphics.clear();
        for(waveSource in waveSources){
            waveSource.draw(delta);
        }
        player.draw(delta);
    }


    override function resize(width:Float, height:Float) {
    }

    override function destroy() {
        super.destroy();

    }

}

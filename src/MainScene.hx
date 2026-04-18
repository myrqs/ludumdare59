package;

import js.html.audio.WaveShaperNode;
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

        this.onPointerDown(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            target.x = info.x;
            target.y = info.y;
            screen.onPointerMove(this, moveTo);
        });

        this.onPointerUp(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            target.x = 0;
            target.y = 0;
            screen.offPointerMove(moveTo);

        });

        graphics = new Graphics();
        graphics.pos(0, 0);
        add(graphics);

        waveSources.push(new WaveSource(200, 400, Color.YELLOW, graphics));
        waveSources.push(new WaveSource(100, 100, Color.RED, graphics));
    }

    function moveTo(info:TouchInfo) {
        target.x = info.x;
        target.y = info.y;
    }

    override function update(delta:Float) {

        if(target.x != 0 || target.y != 0){
            var xdir = target.x - logo.x;
            var ydir = target.y - logo.y;
            log.debug('xdir: ' + xdir + 'ydir: ' + ydir);
            var distance = Math.sqrt(xdir * xdir + ydir * ydir);

            if(distance > 0){

                logo.rotation = (Math.atan2(ydir, xdir) + Math.PI/2) * 180 / Math.PI;

                var nx = xdir / distance;
                var ny = ydir / distance;

                var movex = nx * 50.0 * delta;
                var movey = ny * 50.0 * delta;

                logo.pos(logo.x + movex, logo.y + movey);
            }
        }
        time += delta;
        graphics.clear();
        for(waveSource in waveSources){
            waveSource.draw(delta);
        }

        drawTriangle();
    }

    function drawTriangle() {
        var topX = logo.x;
        var topY = logo.y;

        var rotation = logo.rotation * Math.PI / 180;

        rotation -= Math.PI / 2;

        var length = 500;
        var spread = Math.PI / 3;

        var leftX = topX + Math.cos(rotation + Math.PI + spread) * length;
        var leftY = topY + Math.sin(rotation + Math.PI + spread) * length;

        var rightX = topX + Math.cos(rotation + Math.PI - spread) * length;
        var rightY = topY + Math.sin(rotation + Math.PI - spread) * length;

        graphics.drawLine(topX, topY, leftX, leftY);
        graphics.drawLine(topX, topY, rightX, rightY);

    }

    override function resize(width:Float, height:Float) {
    }

    override function destroy() {
        super.destroy();

    }

}

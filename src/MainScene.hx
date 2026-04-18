package;

import ceramic.Point;
import ceramic.TouchInfo;
import ceramic.Quad;
import ceramic.Scene;

class MainScene extends Scene {

    var logo:Quad;
    var target:Point = Point.get(0,0);

    override function preload() {

        // Add any asset you want to load here

        assets.add(Images.CERAMIC);

    }

    override function create() {

        // Called when scene has finished preloading

        // Display logo
        logo = new Quad();
        logo.texture = assets.texture(Images.CERAMIC);
        logo.anchor(0.5, 0.5);
        logo.pos(width * 0.5, height * 0.5);
        logo.scale(0.0001);
        logo.alpha = 0;
        add(logo);

        // Create some logo scale "in" animation
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
        
        
        // Print some log
        log.success('Hello from ceramic :)');

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
                var nx = xdir / distance;
                var ny = ydir / distance;

                var movex = nx * 50.0 * delta;
                var movey = ny * 50.0 * delta;

                logo.pos(logo.x + movex, logo.y + movey);
                
            }
        }
    }

    override function resize(width:Float, height:Float) {

        // Called everytime the scene size has changed

    }

    override function destroy() {

        // Perform any cleanup before final destroy

        super.destroy();

    }

}

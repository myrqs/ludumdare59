package;

import ceramic.KeyCode;
import ceramic.Key;
import ceramic.Text;
import ceramic.Camera;
import ceramic.Color;
import ceramic.Graphics;
import ceramic.Point;
import ceramic.TouchInfo;
import ceramic.Quad;
import ceramic.Scene;
import ceramic.Sprite;
import ceramic.SpriteSheet;

class MainScene extends Scene {

    var logo:Quad;
    var target:Point = Point.get(0,0);
    var graphics:Graphics;
    var time:Float = 0;
    var waveSources:Array<WaveSource> = new Array<WaveSource>();
    var timer:Int = 0;
    var player:Player;
    var camera:Camera;
    var playerSprite:Sprite;
    var hptext:Text;
    var healingstation:Healingstation;



    override function preload() {
        assets.add(Images.CERAMIC);
        assets.add(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
        assets.add(Images.ZUGVOGEL_SPRITE_NPC_ABLAUF__ABL_UFE_GESAMT);
        assets.add(Sounds.SOUNDS__BIRD_SPEEDUP);
        playerSprite = new Sprite();
        playerSprite.sheet = new SpriteSheet();
        hptext = new Text();
    }

    override function create() {

        //logo = new Quad();
        //logo.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER);
        playerSprite.sheet.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
        playerSprite.sheet.grid(133, 134);
        playerSprite.sheet.addGridAnimation('idle', [0], 0);
        playerSprite.sheet.addGridAnimation('flying', [0,1,2,3,4,5,6], 0.1); 
        playerSprite.animation = 'idle';

        playerSprite.anchor(0.5, 0.5);
        playerSprite.pos(width * 0.5, height * 0.5);
        playerSprite.scale(0.0001);
        playerSprite.alpha = 0;
        add(playerSprite);

        playerSprite.tween(ELASTIC_EASE_IN_OUT, 0.75, 0.0001, 1.0, function(value, time) {
            playerSprite.alpha = value;
            playerSprite.scale(value);
        });


        graphics = new Graphics();
        graphics.pos(0, 0);
        add(graphics);

        player = new Player(graphics, playerSprite);

        this.onPointerDown(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            var pnt = Point.get(0,0);
            screenToVisual(info.x, info.y, pnt);
            player.setTarget(pnt);
            screen.onPointerMove(this, moveTo);
            playerSprite.animation = 'flying';
        });

        this.onPointerUp(this, function(info:TouchInfo) {
            log.debug('clicked ' + info.x + ':' + info.y);
            player.setTarget(Point.get(0, 0));
            screen.offPointerMove(moveTo);
            playerSprite.animation = 'idle';
        });
    
        input.onKeyDown(this, function(key:Key) {
            if(key.keyCode == KeyCode.LSHIFT){
                player.speed = 150.0;
                assets.sound(Sounds.SOUNDS__BIRD_SPEEDUP).play();
            }
        });
        input.onKeyUp(this, function(key:Key) {
            if(key.keyCode == KeyCode.LSHIFT){
                player.speed = 50.0;
            }
        });

        waveSources.push(new WaveSource(200, 400, Color.YELLOW, graphics));
        waveSources.push(new WaveSource(100, 100, Color.RED, graphics));

        camera = new Camera();

        camera.followTarget = true;
        camera.targetX = playerSprite.x;
        camera.targetY = playerSprite.y;

        hptext.color = Color.RED;
        hptext.content = "hitpoints: " + player.hitpoints;
        hptext.pointSize = 48;
        hptext.anchor(0, 0);
        hptext.pos(0, 0);

        healingstation=new Healingstation( 806, 408, Color.GREEN, graphics);
    }

    function moveTo(info:TouchInfo) {
        var pnt = Point.get(0,0);
        screenToVisual(info.x, info.y, pnt);
        player.setTarget(pnt);
    }

    override function update(delta:Float) {
        updateCamera(delta);

        time += delta;
        graphics.clear();
        for(waveSource in waveSources){
            waveSource.draw(delta);
            
            for(wave in waveSource.waves){ //to steal
                if(pointInCircle(playerSprite.x, playerSprite.y, waveSource.x, waveSource.y, 10 * wave.itime)){
                    timer += 1;
                    if(timer >= 100){
                        player.hitpoints -= 1;
                        timer = 0;
                    }
                }
            }
        }
        player.draw(delta);
        hptext.content = 'hitpoints: ' + player.hitpoints;
        healingstation.draw();

        if(pointInCircle(playerSprite.x, playerSprite.y, healingstation.x, healingstation.y, 20 )){
                    timer += 1;
                    if(timer >= 100){
                        player.hitpoints += 1;
                        timer = 0;
                    }
                }
    }
    function pointInCircle(px:Float, py:Float, cx:Float, cy:Float, radius:Float):Bool {
        var dx = px - cx;
        var dy = py - cy;
        return dx * dx + dy * dy <= radius * radius;
    }


    function updateCamera(delta:Float) {
        camera.viewportWidth = width;
        camera.viewportHeight = height;
        camera.contentHeight = 10000;
        camera.contentWidth = 10000;
        camera.clampToContentBounds = false;
        camera.followTarget = true;
        camera.targetX = playerSprite.x;
        camera.targetY = playerSprite.y;

        camera.update(delta);
        this.translateX = camera.contentTranslateX;
        this.translateY = camera.contentTranslateY;
    }

    override function resize(width:Float, height:Float) {
    }

    override function destroy() {
        super.destroy();

    }

}

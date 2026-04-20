package;

import ceramic.GeometryUtils;
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
    public var player:Player;
    var camera:Camera;
    var playerSprite:Sprite;
    var hptext:Text;
    var staminatext:Text;
    var scoretext:Text;
    var xptext:Text;
    var healingstation:Healingstation;
    var goal:Goal;
    var boosting:Bool = false;
    var started:Bool = false;

    var plane:Plane;
    public var eneym:Enemy;
    var npcs:Array<Bird> = new Array<Bird>();

    override function preload() {
        assets.add(Images.CERAMIC);
        assets.add(Images.MAP__HEALSTATION_LAKE);
        assets.add(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
        assets.add(Images.ASSET_RADAR_DISH_SEQUENCE);
        assets.add(Images.ZUGVOGEL_SPRITE_NPC_ABLAUF__ABL_UFE_GESAMT);
        assets.add(Images.ENEMY_GOSHAWK_SEQUENCE);
        assets.add(Images.ALLY_PIGEON_SEQUENCE);
        assets.add(Sounds.SOUNDS__BIRD_SPEEDUP);
        assets.add(Sounds.SOUNDS__PLANE_SHORT_FULL_LOOP);
        assets.add(Sounds.SOUNDS__BASE__PLANE_APPROACHING);
        assets.add(Sounds.SOUNDS__PLANE_ONSCREEN);
        assets.add(Sounds.SOUNDS__PLANE_LEFT);
        assets.add(Sounds.SOUNDS__BASE__PLANE_DEATH);
        assets.add(Images.DANGER_PLANE_SEQUENCE_TEST);
        playerSprite = new Sprite();
        playerSprite.sheet = new SpriteSheet();
        hptext = new Text();
        staminatext = new Text();
        scoretext = new Text();
        xptext = new Text();
    }

    override function create() {
        scale(0.5,0.5);
        //logo = new Quad();
        //logo.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER);
        playerSprite.sheet.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
        playerSprite.sheet.grid(133, 134);
        playerSprite.sheet.addGridAnimation('idle', [0], 0);
        playerSprite.sheet.addGridAnimation('flying', [0,1,2,3,4,5,6], 0.1); 
        playerSprite.animation = 'idle';
        playerSprite.scale(1.0);
        playerSprite.anchor(0.5, 0.5);
        playerSprite.pos(width * 0.5, height * 0.5);
        playerSprite.alpha = 1;
        add(playerSprite);

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
                if (!boosting) {
                boosting = true;
                player.speed = 350.0;
                assets.sound(Sounds.SOUNDS__BIRD_SPEEDUP).play();
                }
                player.stamina -=1;
            }
            if(key.keyCode == KeyCode.SPACE) {
                player.shootBird(eneym);
            }
        });
        input.onKeyUp(this, function(key:Key) {
            if(key.keyCode == KeyCode.LSHIFT){
                boosting = false;
                player.speed = 50.0;
            }
        });

        waveSources.push(new WaveSource(200, 400, Color.YELLOW, graphics));
        waveSources.push(new WaveSource(100, 100, Color.RED, graphics));

        for(waveSource in waveSources){
            add(waveSource);
        }

        camera = new Camera();
 
        camera.followTarget = true;
        camera.targetX = playerSprite.x;
        camera.targetY = playerSprite.y;

        hptext.color = Color.RED;
        hptext.content = "hitpoints: " + player.hitpoints;
        hptext.pointSize = 48;
        hptext.anchor(0, 0);
        hptext.pos(0, 0);

        staminatext.color = Color.GREEN;
        staminatext.content = "stamina: " + player.stamina;
        staminatext.pointSize = 48;
        staminatext.anchor(0, 0);
        staminatext.pos(350, 0);

        scoretext.color = Color.YELLOW;
        scoretext.content = "score: " + player.score;
        scoretext.pointSize = 48;
        scoretext.anchor(0, 0);
        scoretext.pos(700, 0);

        xptext.color = Color.WHITE;
        xptext.content = "score: " + player.score;
        xptext.pointSize = 48;
        xptext.anchor(0, 0);
        xptext.pos(700, 200);
        eneym = new Enemy(1000, 1000, graphics);
        add(eneym);
        healingstation=new Healingstation( 806, 408, Color.GREEN, graphics);
        add(healingstation);
        goal=new Goal( 6, 808, Color.YELLOW, graphics);

        for(i in 0...10){
            var tmpx = Std.random(500);
            var tmpy = Std.random(500);
            var chance = Std.random(100);
            var tmp:Bird;
            if(chance < 10){
                tmp = new Pigeon(tmpx, tmpy);
            } else {
                tmp = new JourneyBird(tmpx, tmpy);
            }
            npcs.push(tmp);
            add(tmp);
            tmp.setTarget(Point.get(tmpx, tmpy+10));
        }
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
        for(npc in npcs){
            //graphics.lineStyle(2, Color.CORAL);
            //graphics.drawRect(npc.x, npc.y, npc.width * npc.scaleX, npc.height * npc.scaleY);
            if(GeometryUtils.pointInRectangle(playerSprite.x, playerSprite.y, npc.x, npc.y, npc.width * npc.scaleX, npc.height * npc.scaleY)){
                if(!npc.following){
                    player.addBird(npc);
                    npc.following = true;
                }
            }
            npc.update(delta);
        }
        if(GeometryUtils.pointInRectangle(playerSprite.x, playerSprite.y, eneym.x, eneym.y, eneym.width * eneym.scaleX, eneym.height * eneym.scaleY)){
            player.hitpoints -= 1;
        }
        for(waveSource in waveSources){
            waveSource.draw(delta);
            
            for(wave in waveSource.waves){ //to steal
                if(pointInCircle(playerSprite.x, playerSprite.y, waveSource.x, waveSource.y, 10 * wave.itime)){
                    timer += 1;
                    if(timer >= 100){
                        player.hitpoints -= 1;
                        if(player.hitpoints == 90){
                            plane = new Plane();
                            log.debug('plane created');
                            var pnt:Point = Point.get(0, 0);
                            screenToVisual(0, 0, pnt);
                            plane.anchor(0.5,0.5);
                            plane.x = -3800;
                            plane.y = playerSprite.y;
                            plane.width = 600;
                            plane.height = 200;
                            assets.sound(Sounds.SOUNDS__PLANE_SHORT_FULL_LOOP).play();
                            add(plane);
                        }
                        timer = 0;
                    }
                }
            }
        }

        if (player.stamina<=0) {
            boosting=false;
            player.speed= 50.0;
        }
        if(plane != null) {
            plane.x += 5;
        }
        player.draw(delta);
        eneym.update(delta);
        eneym.setTarget(Point.get(playerSprite.x, playerSprite.y));
        
        hptext.content = 'hitpoints: ' + player.hitpoints;
        scoretext.content = 'score: ' + player.score;
        xptext.content = 'xp: ' + player.xp;
        staminatext.content = 'stamina: ' + Math.floor (player.stamina);
        player.stamina +=0.1;
        healingstation.draw();
        healingstation.update(delta);

        if(pointInCircle(playerSprite.x, playerSprite.y, healingstation.x, healingstation.y, 20 )){
                    timer += 1;
                    if(timer >= 100){
                        player.hitpoints += 1;
                        timer = 0;
                    }
                }

        goal.draw();

        if(pointInCircle(playerSprite.x, playerSprite.y, goal.x, goal.y, 20 )){
            player.wincondition(goal);
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
        camera.trackSpeedX = 80;
        camera.trackSpeedY = 80;
        camera.frictionX = 1;
        camera.frictionY = 1;
        camera.trackCurve = 1;


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

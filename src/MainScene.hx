package;

import clay.Types.TextureFilter;
import ceramic.TextureFilter;
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
	var background:Quad;
	var target:Point = Point.get(0, 0);
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
	var starttext:Text;
	var goal:Goal;
	var boosting:Bool = false;
	var started:Bool = false;
    var won:Bool = false;
	var boostSoundPlayed:Bool = false;
	var planeTimer:Float = 0;
	var enemyTimer:Float = 0;
	var plane:Plane;
    var npcTimer:Float = 0;
    var currentLevel:Int = 1;
    var maxEnemies:Int = 1;
    var planeIntervall:Int = 60;
    var maxWaveSources:Int = 3;

	public var enemies:Array<Enemy> = new Array<Enemy>();
	public var npcs:Array<Bird> = new Array<Bird>();
    public var projectiles:Array<Projectile> = new Array<Projectile>();

    var hudquad = new Quad();
    var hud = new Quad();
    var abilityQuad = new Quad();
    var ability1 = new Quad();
    var ability2 = new Quad();
    var ability3 = new Quad();
    var ability1available:Bool = false;
    var ability2available:Bool = false;
    var ability3available:Bool = false;
    var scorelimit:Int;

	function spawnEnemy(x:Float, y:Float) {
		var enemy = new Enemy(x, y, graphics);
		enemies.push(enemy);
		add(enemy);
        enemy.depth = 3;
	}

	function spawnNPC() {
		var tmpx = Std.random(2000);
		var tmpy = Std.random(2000);
		var chance = Std.random(100);
		var tmp:Bird;
		if (chance < 10) {
			tmp = new Pigeon(tmpx, tmpy);
		} else if (chance < 25) {
			tmp = new Seagull(tmpx, tmpy);
		} else {
			tmp = new JourneyBird(tmpx, tmpy);
		}
		npcs.push(tmp);
		add(tmp);
		tmp.setTarget(Point.get(tmpx, tmpy + 10));
	}

	function damagePlayer(amount:Int) {
		player.hitpoints -= amount;
		if (player.hitpoints < 0)
			player.hitpoints = 0;
	}

    function spawnWaveSource() {
        var tmpx = Std.random(2000);
        var tmpy = Std.random(1000);

        var wavesource = new WaveSource(tmpx, tmpy, Color.YELLOW, graphics);
        waveSources.push(wavesource);
        add(wavesource);
    }

	override function preload() {
		assets.add(Images.CERAMIC);
		assets.add(Images.MAP__HEALSTATION_LAKE);
		assets.add(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
		assets.add(Images.ASSET_RADAR_DISH_SEQUENCE);
		assets.add(Images.ZUGVOGEL_SPRITE_NPC_ABLAUF__ABL_UFE_GESAMT);
		assets.add(Images.MAP__CLOUD_SEQUENCE_1);
		assets.add(Images.MAP__CLOUD_SEQUENCE_2);
		assets.add(Images.MAP__CLOUD_SEQUENCE_3);
		assets.add(Images.ENEMY_GOSHAWK_SEQUENCE);
		assets.add(Images.ALLY_PIGEON_SEQUENCE);
		assets.add(Images.ALLY_SEAGULL_SEQUENCE);
		assets.add(Sounds.SOUNDS__BIRD_SPEEDUP);
		assets.add(Sounds.SOUNDS__PLANE_SHORT_FULL_LOOP);
		assets.add(Sounds.SOUNDS__BASE__PLANE_APPROACHING);
		assets.add(Sounds.SOUNDS__PLANE_ONSCREEN);
		assets.add(Sounds.SOUNDS__PLANE_LEFT);
		assets.add(Sounds.SOUNDS__BASE__PLANE_DEATH);
		assets.add(Sounds.SOUNDS__ENEMY_BIRD_SPAWN);
		assets.add(Sounds.SOUNDS__BIRD_SHOOTING);
		assets.add(Sounds.SOUNDS__ENEMY_BIRD_DEATH);
        assets.add(Sounds.SOUNDS__BIRRD_SPAWN);
        assets.add(Sounds.SOUNDS__POOPATTACK);
        assets.add(Sounds.SOUNDS__BIRD_PICKUP);
        assets.add(Sounds.SOUNDS__POWERUP_READY);
        assets.add(Sounds.SOUNDS__POWERUP_NOT_AVAILABLE_FULL);
        assets.add(Sounds.SOUNDS__DEATH_TO_AIRPLANE);
        assets.add(Sounds.SOUNDS__WINGFLAP_FOR_LOOP);
        assets.add(Sounds.SOUNDS__HEALINGFIELD); //Radar
        assets.add(Sounds.SOUNDS__LVL_UP_SOUND);
        assets.add(Sounds.SOUNDS__BASE_EXPLOSION);
        assets.add(Sounds.SOUNDS__FANFARE);
        assets.add(Sounds.SOUNDS__BGM1);
		assets.add(Images.DANGER_PLANE_SEQUENCE_TEST);
		assets.add(Images.MAP__MAP_1_GREEN_CITY);
        assets.add(Images.MAP__MAP_2_GREEN_PLANES);
        assets.add(Images.MAP__MAP_3_ORANGE_FIELDS);
        assets.add(Images.MAP__MAP_4_ORANGE_BLUE_LAKE);
        assets.add(Images.MAP__MAP_5_BLUE_RIVER);
        assets.add(Images.MAP__MAP_6_BLUE_GREEN_ISLE);
        assets.add(Images.MAP__MAP_7_BLUE_GREEN_BEACH);
        assets.add(Images.MAP__GAME_HUD_GR_BER);
        assets.add(Images.MAP__TITLESCREEN_GAME_OVER);
        assets.add(Images.MAP__TITLESCREEN_START);
        assets.add(Images.MAP__TITLESCREEN_SURVIVED);
        assets.add(Images.ABILITIES_ICONS_COUNTER__ABILITIES_COUNTER);
        assets.add(Images.ABILITIES_ICONS_COUNTER__ALLY_JOURNEYBIRD_SYMBOL);
        assets.add(Images.ABILITIES_ICONS_COUNTER__ALLY_PIGEON_SYMBOL);
        assets.add(Images.ABILITIES_ICONS_COUNTER__ALLY_SEAGULL_SYMBOL);
		starttext = new Text();
	}

	function startLevel(level:Int) {
		starttext.destroy();
        won = false;

        scorelimit = level * 100;
        maxEnemies = level;
        planeIntervall = 60 - level * 2;
        maxWaveSources = 3 + level;

		graphics = new Graphics();
		graphics.pos(0, 0);
		add(graphics);

		hptext = new Text();
		staminatext = new Text();
		scoretext = new Text();
		xptext = new Text();
        add(hptext);
        add(staminatext);
        add(scoretext);
        add(xptext);

        hud = new Quad();
        hud.texture = assets.texture(Images.MAP__GAME_HUD_GR_BER);
        hud.depth = 12;
        hud.scale(2);
        add(hud);

        background.destroy();
        background = new Quad();
        if(level == 1) background.texture = assets.texture(Images.MAP__MAP_1_GREEN_CITY);
        else if(level == 2) background.texture = assets.texture(Images.MAP__MAP_2_GREEN_PLANES);
        else if(level == 3) background.texture = assets.texture(Images.MAP__MAP_3_ORANGE_FIELDS);
        else if(level == 4) background.texture = assets.texture(Images.MAP__MAP_4_ORANGE_BLUE_LAKE);
        else if(level == 5) background.texture = assets.texture(Images.MAP__MAP_5_BLUE_RIVER);
        else if(level == 6) background.texture = assets.texture(Images.MAP__MAP_6_BLUE_GREEN_ISLE);
        else if(level == 7) background.texture = assets.texture(Images.MAP__MAP_7_BLUE_GREEN_BEACH);
		
		background.alpha = 0.75;
		add(background);
		background.scale(2);

		for (i in 0...5) {
			add(new Cloud(Std.random(1500), Std.random(1500)));
		}

		for (i in 0...maxWaveSources) {
            spawnWaveSource();
		}
		goal = new Goal(Std.random(1500), Std.random(1500), Color.YELLOW, graphics);
        add(goal);
        goal.depth = 1;

		for (i in 0...20) {
			spawnNPC();
		}

		playerSprite = new Sprite();
		playerSprite.sheet = new SpriteSheet();
		playerSprite.sheet.texture = assets.texture(Images.ZUGVOGEL_SPRITE_ANF_HRER_ABLAUF__ANF_HRER_ABLAUF_GESAMT);
		playerSprite.sheet.grid(133, 134);
		playerSprite.sheet.addGridAnimation('idle', [0], 0);
		playerSprite.sheet.addGridAnimation('flying', [0, 1, 2, 3, 4, 5, 6], 0.1);
		playerSprite.animation = 'idle';
		playerSprite.scale(1.0);
		playerSprite.anchor(0.5, 0.5);
		playerSprite.pos(width * 0.5, height * 0.5);
		playerSprite.alpha = 1;
		add(playerSprite);

        if(player == null) player = new Player(graphics, playerSprite);
        player.logo = playerSprite;
        playerSprite.depth = 2;

		setupHUD();
		started = true;
	}

	override function create() {
		scale(0.5, 0.5);
        background = new Quad();
		this.onPointerDown(this, function(info:TouchInfo) {
			if (started) {
				log.debug('clicked ' + info.x + ':' + info.y);
				var pnt = Point.get(0, 0);
				screenToVisual(info.x, info.y, pnt);
				player.setTarget(pnt);
				screen.onPointerMove(this, moveTo);
				playerSprite.animation = 'flying';
			}
		});

		this.onPointerUp(this, function(info:TouchInfo) {
			if (started) {
				log.debug('clicked ' + info.x + ':' + info.y);
				player.setTarget(Point.get(0, 0));
				screen.offPointerMove(moveTo);
				playerSprite.animation = 'idle';
			}
		});

		input.onKeyDown(this, function(key:Key) {
			if (key.keyCode == KeyCode.LSHIFT) {
				if (started) {
					if (player.stamina > 20) {
						if (!boosting) {
							boosting = true;
							player.speed = 350.0;
							if (!boostSoundPlayed) {
								assets.sound(Sounds.SOUNDS__BIRD_SPEEDUP).play();
								boostSoundPlayed = true;
							}
						}
						player.stamina -= 4;
						if (player.stamina > 100)
							player.stamina = 100;
						if (player.stamina < 10)
							player.stamina = 0;
						if (player.stamina <= 20) {
							boosting = false;
							player.speed = 50.0;
						}
					}
				}
			}

			if (key.keyCode == KeyCode.SPACE) {
				if(won){
                    startLevel(currentLevel += 1);
                } else if(!started) {
					startLevel(currentLevel);
				}
			}

            if(started == true){
                if(key.keyCode == KeyCode.KEY_1){
                    if(ability1available == true){
                        ability1.tween(ELASTIC_EASE_IN_OUT, 1, 0.3, 0.25, function(value, time) {
                            ability1.scale(value);
                        });
                        player.shootBird(enemies[Std.random(enemies.length)]);
                    } else {
                        assets.sound(Sounds.SOUNDS__POWERUP_NOT_AVAILABLE_FULL).play(); 
                        ability1.tween(ELASTIC_EASE_IN_OUT, 1, 15, 0, function(value, time) {
                            ability1.rotation = value;
                        });
                    }
                }
                if(key.keyCode == KeyCode.KEY_2){
                    if(ability2available == true){
                        ability2.tween(ELASTIC_EASE_IN_OUT, 1, 1.3, 1.0, function(value, time) {
                            ability2.scale(value);
                        });
                        player.jam();
                    } else {
                        assets.sound(Sounds.SOUNDS__POWERUP_NOT_AVAILABLE_FULL).play(); 
                        ability2.tween(ELASTIC_EASE_IN_OUT, 1, 15, 0, function(value, time) {
                            ability2.rotation = value;
                        });
                    }
                }
                if(key.keyCode == KeyCode.KEY_3){
                    if(ability3available == true){
                        ability3.tween(ELASTIC_EASE_IN_OUT, 1, 1.3, 1.0, function(value, time) {
                            ability3.scale(value);
                        });
                        player.attack();
                    } else {
                        assets.sound(Sounds.SOUNDS__POWERUP_NOT_AVAILABLE_FULL).play(); 
                        ability3.tween(ELASTIC_EASE_IN_OUT, 1, 15, 0, function(value, time) {
                            ability3.rotation = value;
                        });
                    }
                }
            }
		});
		input.onKeyUp(this, function(key:Key) {
			if (key.keyCode == KeyCode.LSHIFT) {
				boosting = false;
				player.speed = 50.0;
			}
		});

		starttext.color = Color.CORAL;
		starttext.content = "Press Space to start";
		starttext.pointSize = 96;
		starttext.anchor(0, 0);
		starttext.pos(20, 90);

        background.texture = assets.texture(Images.MAP__TITLESCREEN_START);
        background.texture.filter = TextureFilter.NEAREST;
        background.scale(8.2);
	}

	function moveTo(info:TouchInfo) {
		var pnt = Point.get(0, 0);
		screenToVisual(info.x, info.y, pnt);
		player.setTarget(pnt);
	}

	override function update(delta:Float) {
		if (started) {
			graphics.clear();

			time += delta;
			for (npc in npcs) {
				 //graphics.lineStyle(2, Color.CORAL);
				 //graphics.drawRect(npc.x, npc.y, npc.width * npc.scaleX, npc.height * npc.scaleY);
				if (GeometryUtils.pointInRectangle(playerSprite.x, playerSprite.y, npc.x, npc.y, npc.width * npc.scaleX, npc.height * npc.scaleY)) {
					if (!npc.following) {
						player.addBird(npc);
						npc.following = true;
                        assets.sound(Sounds.SOUNDS__BIRD_PICKUP).play();
					}
				}
                if (pointInCircle(npc.x, npc.y, goal.x, goal.y, (goal.width/2)/4)) {
                    npcs.remove(npc);
                    npc.destroy();
                }
				npc.update(delta);
			}

            npcTimer += delta;
            if (npcs.length <= 10 && npcTimer >= 1) {
                npcTimer = 0;
                spawnNPC();
                assets.sound(Sounds.SOUNDS__BIRRD_SPAWN).play();
            }

			for (enemy in enemies) {
				if (GeometryUtils.pointInRectangle(playerSprite.x, playerSprite.y, enemy.x, enemy.y, enemy.width * enemy.scaleX, enemy.height * enemy.scaleY)) {
					player.hitpoints -= 1;
					if (player.hitpoints < 0)
						player.hitpoints = 0;
				}
				enemy.update(delta);
				enemy.setTarget(Point.get(playerSprite.x, playerSprite.y));
			}

			enemyTimer += delta;
			if (enemies.length <= maxEnemies && enemyTimer >= 20) {
				enemyTimer = 0;

				var x = Std.random(2000);
				var y = Std.random(2000);

				spawnEnemy(x, y);
				assets.sound(Sounds.SOUNDS__ENEMY_BIRD_SPAWN).play();
			}

			for (waveSource in waveSources) {
				waveSource.draw(delta);

				for (wave in waveSource.waves) { // to steal
					if (pointInCircle(playerSprite.x, playerSprite.y, waveSource.x, waveSource.y, 10 * wave.itime)) {
						timer += 1;
						if (timer >= 100) {
                            player.radarconfusion(waveSource);
							timer = 0;
						}
					}
				}
			}

			if (player.stamina <= 0) {
				boosting = false;
				player.speed = 50.0;
			}

			if (player != null) {
				player.draw(delta);
			}

			if (plane != null) {
				plane.x += 5;
                if (plane.x >= 3000) {
					plane.destroy();
				}
				if (GeometryUtils.pointInRectangle(playerSprite.x, playerSprite.y, plane.x, plane.y, 300, 150)) {
					damagePlayer(100);
                    assets.sound(Sounds.SOUNDS__DEATH_TO_AIRPLANE).play();
				}
			}

			planeTimer += delta;
			if (planeTimer >= planeIntervall) {
				planeTimer = 0;
				plane = new Plane();
				plane.x = -3500;
				plane.y = playerSprite.y;
				assets.sound(Sounds.SOUNDS__PLANE_SHORT_FULL_LOOP).play();
				add(plane);
			}

			hptext.content = 'HP: ' + player.hitpoints;
			scoretext.content = 'SCR: ' + player.score;
            staminatext.content = 'STM: ' + Math.floor(player.stamina);
			xptext.content = 'XP: \n' + player.xp;
			player.stamina += 0.1;
			if (player.stamina > 100)
				player.stamina = 100;
			if (player.stamina < 10)
				player.stamina = 10;
			if (player.stamina >= 80) {
				boostSoundPlayed = false;
			}

			goal.draw();
            
			if (pointInCircle(playerSprite.x, playerSprite.y, goal.x, goal.y, (goal.width/2)/4)) {
				player.wincondition(goal);
			}

			if (player.hitpoints <= 0) {
				started = false;
				starttext = new Text();
				starttext.color = Color.CORAL;
				starttext.content = "Game Over!\nPress Space to start";
				starttext.pointSize = 96;
				starttext.anchor(0, 0);
				starttext.pos(20, 20);
				clear();
				npcs = new Array<Bird>();
				enemies = new Array<Enemy>();
				waveSources = new Array<WaveSource>();
                background = new Quad();
                background.texture = assets.texture(Images.MAP__TITLESCREEN_GAME_OVER);
                background.texture.filter = TextureFilter.NEAREST;
                background.scale(16.5);
                add(background);
			}

            if(player.score >= scorelimit){
                started = false;
                won = true;
				starttext = new Text();
				starttext.color = Color.CORAL;
				starttext.content = "Level " + currentLevel + " Won!\nPress Space to start";
				starttext.pointSize = 96;
				starttext.anchor(0, 0);
				starttext.pos(20, 20);
				clear();
				npcs = new Array<Bird>();
				enemies = new Array<Enemy>();
				waveSources = new Array<WaveSource>();
                background = new Quad();
                background.texture = assets.texture(Images.MAP__TITLESCREEN_SURVIVED);
                background.texture.filter = TextureFilter.NEAREST;
                background.scale(16.5);
                add(background);
            }
            checkAbilityAvailability();
            for(projectile in projectiles){
                projectile.update(delta);
            }
		} else {}
	}

	function pointInCircle(px:Float, py:Float, cx:Float, cy:Float, radius:Float):Bool {
		var dx = px - cx;
		var dy = py - cy;
		return dx * dx + dy * dy <= radius * radius;
	}

    function checkAbilityAvailability() {
        if(player.checkForBird(Pigeon)){
            ability2.color = Color.BLACK;
            ability2available = true;
        } else {
            ability2.color = Color.GRAY;
            ability2available = false;
        }
        if(player.checkForBird(JourneyBird)){
            ability1.color = Color.BLACK;
            ability1available = true;
        } else {
            ability1.color = Color.GRAY;
            ability1available = false;
        }
        if(player.checkForBird(Seagull)){
            ability3.color = Color.BLACK;
            ability3available = true;
        } else {
            ability3.color = Color.GRAY;
            ability3available = false;
        }
    }

	function setupHUD() {
        hudquad = new Quad();
        hudquad.x = 630;
        hudquad.y = 30;
        hudquad.width = 810;
        hudquad.height = 125;
        hudquad.color = Color.BLACK;
        hudquad.depth = 11;
        add(hudquad);

        abilityQuad = new Quad();
        abilityQuad.x = 500;
        abilityQuad.y = 1280;
        abilityQuad.depth = 10;
        abilityQuad.texture = assets.texture(Images.ABILITIES_ICONS_COUNTER__ABILITIES_COUNTER);
        abilityQuad.texture.filter = TextureFilter.NEAREST;
        abilityQuad.scale(4);
        abilityQuad.anchor(0.5,0.5);
        add(abilityQuad);

        ability1 = new Quad();
        ability1.x = 27;
        ability1.y = 29;
        ability1.width = 100;
        ability1.height = 100;
        ability1.color = Color.GRAY;
        ability1.depth = 11;
        ability1.anchor(0.5,0.5);
        ability1.scale(0.25);
        ability1.texture = assets.texture(Images.ABILITIES_ICONS_COUNTER__ALLY_JOURNEYBIRD_SYMBOL);
        abilityQuad.add(ability1);

        ability2 = new Quad();
        ability2.x = 78;
        ability2.y = 26;
        ability2.width = 100;
        ability2.height = 100;
        ability2.color = Color.GRAY;
        ability2.depth = 11;
        ability2.anchor(0.5,0.5);
        ability2.texture = assets.texture(Images.ABILITIES_ICONS_COUNTER__ALLY_PIGEON_SYMBOL);
        ability2.texture.filter = TextureFilter.NEAREST;
        ability2.scale(1);
        abilityQuad.add(ability2);

        ability3 = new Quad();
        ability3.x = 125;
        ability3.y = 29;
        ability3.width = 100;
        ability3.height = 100;
        ability3.color = Color.GRAY;
        ability3.depth = 11;
        ability3.anchor(0.5,0.5);
        ability3.texture = assets.texture(Images.ABILITIES_ICONS_COUNTER__ALLY_SEAGULL_SYMBOL);
        ability3.texture.filter = TextureFilter.NEAREST;
        ability3.scale(1);
        abilityQuad.add(ability3);

		hptext.color = Color.RED;
		hptext.content = "HP: " + player.hitpoints;
		hptext.pointSize = 48;
		hptext.anchor(0, 0);
		hptext.pos(660, 60);
        hptext.depth = 12;

		staminatext.color = Color.ORANGE;
		staminatext.content = "STM: " + player.stamina;
		staminatext.pointSize = 42;
		staminatext.anchor(0, 0);
		staminatext.pos(890, 60);
        staminatext.depth = 12;

		scoretext.color = Color.YELLOW;
		scoretext.content = "SCR: " + player.score;
		scoretext.pointSize = 48;
		scoretext.anchor(0, 0);
		scoretext.pos(1120, 60);
        scoretext.depth = 12;

		xptext.color = Color.PURPLE;
		xptext.content = "XP: \n" + player.score;
		xptext.pointSize = 42;
		xptext.anchor(0, 0);
		xptext.pos(1340, 60);
        xptext.depth = 12;
	}

	override function resize(width:Float, height:Float) {}

	override function destroy() {
		super.destroy();
	}
}

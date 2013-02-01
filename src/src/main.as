import flash.geom.Point;
import flash.utils.Timer;
import TileGame.Animations.*;
import TileGame.Objects.*;
import TileGame.Players.*;
import TileGame.Tiles.*;
import flash.events.*;
import flash.ui.Keyboard;
import com.greensock.*;
import mx.controls.Label;
import mx.controls.Button;

private const TILE_SIDE_LENGTH:int = 40;
private const NUMBER_OF_ENEMIES:int = 2;

private var myHero:Hero = null;
private var enemy1:Enemy = null;
private var currKC:uint = 0;
private var tileArr:Array = new Array();
private var enemyArr:Array = new Array();
private var enemyShootFlags:Array = new Array();
private var bulletArr:Array = new Array();
private var enemyBullets:Array = new Array();
private var lblFPS:Label = null;
private var lblAvg:Label = null;
private var lblMouseCoords:Label = null;
private var btnReset:Button = null;

private var cnt:int = 0;
private var fpsTime:Number = getTimer();

private function init():void {
	this.setFocus(); //setting focus is necessary to dispatch keyboard events

	//create grid
	var map:Array = [
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1],
		[1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1],
		[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	];
	
	var x:int = 0;
	var y:int = 0;
	for (var i:int = 0; i < map.length; ++i ) {
		tileArr.push(new Array());
		
		for (var j:int = 0; j < map[i].length; ++j) {
			var t:BaseTile = null;
			if (map[i][j] == 0) t = new BaseTile(TILE_SIDE_LENGTH, TILE_SIDE_LENGTH, x, y);
			else if(map[i][j] == 1) t = new WallTile(TILE_SIDE_LENGTH, TILE_SIDE_LENGTH, x, y);
			t.draw(this);
			tileArr[i].push(t);
			
			x += TILE_SIDE_LENGTH;
		} //end for
		x = 0;
		y += TILE_SIDE_LENGTH;
	} //end for
	
	reset(null);
	
	//add enemies
	var e:Enemy = null;
	var enemyTimer:Timer = null;
	for (var k:int = 0; k < NUMBER_OF_ENEMIES; ++k) {
		e = new Enemy(this, 200, 200);
		e.speed = 2;
		e.setMapData(tileArr, TILE_SIDE_LENGTH);
		enemyArr.push(e);
		
		enemyTimer = new Timer(getRandomNumberRange(2000, 5000), 1);
		enemyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, enableEnemyShooting);
		//enemyShootFlags.push(new Array(2) [enemyTimer, false] );
		enemyTimer.start();
	} //end for
	
	//attach event listeners
	addEventListener(Event.ENTER_FRAME, onEnterFrame);
	addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	addEventListener(Event.ACTIVATE, onActivate);
	addEventListener(MouseEvent.MOUSE_MOVE, moveMouse);
	addEventListener(MouseEvent.CLICK, clickMouse);
	
	//add reset button
	btnReset = new Button();
	btnReset.label = "Reset Hero";
	btnReset.x = 500;
	btnReset.y = 10;
	btnReset.addEventListener(MouseEvent.CLICK, reset);
	btnReset.enabled = false;
	addChildAt(btnReset, this.numChildren);
	
	//add FPS textbox
	lblFPS = new Label();
	lblFPS.text = "fps: 0";
	lblFPS.x = 400;
	lblFPS.y = 440;
	addChildAt(lblFPS, this.numChildren);
	
	lblAvg = new Label();
	lblAvg.text = "max: 0";
	lblAvg.x = 460;
	lblAvg.y = 440;
	addChildAt(lblAvg, this.numChildren);
	
	lblMouseCoords = new Label();
	lblMouseCoords.text = "x:0, y:0";
	lblMouseCoords.x = 40;
	lblMouseCoords.y = 440;
	addChildAt(lblMouseCoords, this.numChildren);
} //end method init

public function enableEnemyShooting(evt:TimerEvent):void {
	trace(evt.target);
	trace(evt.currentTarget);
} //end method enableEnemyShooting

private var currfps:Number = 0;
private var avgfps:Number = 0;
private var minfps:int = 60;
private var cntfps:uint = 0;
private var totfps:uint = 0;
public function onEnterFrame(e:Event):void {
	//move hero
	if (myHero) myHero.move(currKC);
	
	//move enemies
	for (var i:int = 0; i < enemyArr.length; ++i) {
		enemyArr[i].move(currKC);
		
		//if we run into an enemy, we're dead
		if (myHero && myHero.isCollidingWith(enemyArr[i])) {
		//if (myHero && myHero.hitTestObject(enemyArr[i])) {
			myHero.kill();
			myHero = null;
			
			btnReset.enabled = true;
			
			break;
		} //end if
		
		for (var n:int = 0; n < bulletArr.length; ++n) {
			if (!bulletArr[n].parent) {
				bulletArr[n] = null;
				bulletArr.splice(n, 1);
				break;
			} //end if
			
			if (enemyArr[i].isCollidingWith(bulletArr[n])) {
			//if (enemyArr[i].hitTestObject(bulletArr[n])) {
				//destroy bullet
				bulletArr[n].destroy();
				bulletArr[n] = null;
				bulletArr.splice(n, 1);
				
				//destroy enemy
				enemyArr[i].kill();
				enemyArr[i] = null;
				enemyArr.splice(i, 1);
				
				break;
			} //end if
		} //end for
	} //end for
	
	/**************
	 * DEBUG CODE *
	 **************/
	
	//write FPS
	currfps = 1000 / (getTimer() - fpsTime);
	if (cnt++ % 5 == 0) {
		currfps = Math.round(currfps);
		++cntfps;
		totfps += currfps;
		avgfps = totfps / cntfps;
		
		lblFPS.text = "fps: " + currfps;
		lblAvg.text = "avg: " + avgfps.toFixed(2);
	} //end if
	fpsTime = getTimer();
} //end method onEnterFrame

public function reset(e:MouseEvent):void {
	//add hero character
	var heroStartTile:BaseTile = getRandomTile();
	var halfTileLength:Number = TILE_SIDE_LENGTH / 2;
	myHero = new Hero(this, heroStartTile.points.TopLeft.x + halfTileLength, heroStartTile.points.TopLeft.y + halfTileLength);
	myHero.speed = 2;
	myHero.setMapData(tileArr, TILE_SIDE_LENGTH);
	myHero.addEventListener(MouseEvent.CLICK, clickHero);
	if(btnReset) btnReset.enabled = false;
} //end method reset

public function getRandomTile():BaseTile {
	var tileX:int = 0;
	var tileY:int = 0;
	
	while (true) {
		tileX = Math.floor(Math.random() * tileArr.length);
		tileY = Math.floor(Math.random() * tileArr[0].length);
		
		if (tileArr[tileX][tileY] is BaseTile && !(tileArr[tileX][tileY] is WallTile))
			return tileArr[tileX][tileY];
	} //end while
	
	return null;
} //end method getRandomTile

public function onKeyDown(e:KeyboardEvent):void {
	currKC = e.keyCode;
} //end method onKeyDown

public function onKeyUp(e:KeyboardEvent):void {
	currKC = 0;
} //end method onKeyUp

public function onActivate(e:Event):void {
	this.setFocus(); //setting focus is necessary to dispatch keyboard events
} //end method onActivate

public function clickHero(e:MouseEvent):void {
} //end method clickHero

public function moveMouse(e:MouseEvent):void {
	lblMouseCoords.text = "x: " + e.stageX + ", y:" + e.stageY;
} //end method moveMouse

public function clickMouse(e:MouseEvent):void {
		if(myHero) bulletArr.push(myHero.shoot());
} //end method clickMouse

private function getRandomNumberRange(min:Number, max:Number):Number {
	return Math.random() * (max - min) + min;
} //end method getRandomNumberRange
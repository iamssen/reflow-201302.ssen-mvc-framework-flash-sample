package ssen.mvc.samples.flash.view {
	import de.polygonal.ds.pooling.ObjectPool;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import ssen.mvc.samples.flash.model.Ball;

	public class BallCanvas extends Sprite {
		private var _height:int=10;
		private var _width:int=10;
		private var list:Vector.<Ball>;
		private var invalidated:Boolean;
		private var drawNow:Boolean;
		private var store:Vector.<BallSprite>;
		private var pool:ObjectPool;

		public function BallCanvas() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			drawNow=true;
			invalidate();
		}

		//=========================================================
		// invalidation
		//=========================================================
		private function addedToStageHandler(event:Event):void {
			//---------------------------------------
			// startup
			//---------------------------------------
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, clearAllBalls, false, 0, true);

			pool=new ObjectPool(1000);
			pool.allocate(BallSprite);

			doubleClickEnabled=true;

			//---------------------------------------
			// invalidation
			//---------------------------------------
			if (invalidated) {
				invalidated=false;

				stage.addEventListener(Event.RENDER, renderHandler, false, 0, true);
				stage.invalidate();
			}
		}

		private function invalidate():void {
			if (stage) {
				stage.addEventListener(Event.RENDER, renderHandler, false, 0, true);
				stage.invalidate();
			} else {
				invalidated=true;
			}
		}

		private function renderHandler(event:Event):void {
			if (stage) {
				stage.removeEventListener(Event.RENDER, renderHandler);
			}

			if (drawNow) {
				drawNow=false;
				draw();
			}
		}

		//=========================================================
		// handler
		//=========================================================
		private function doubleClickHandler(event:MouseEvent):void {
			var evt:BallCanvasEvent=new BallCanvasEvent(BallCanvasEvent.CREATE_BALL);
			evt.xpos=event.localX / _width;
			evt.ypos=event.localY / _height;

			dispatchEvent(evt);
		}

		//=========================================================
		// public api
		//=========================================================
		public function setBallList(list:Vector.<Ball>):void {
			this.list=list;
			drawNow=true;
			invalidate();
		}

		public function deconstruct():void {
			removeBalls();
			list=null;
			pool.free();
			pool=null;
		}

		//=========================================================
		// override 
		//=========================================================
		override public function get height():Number {
			return _height;
		}

		override public function set height(value:Number):void {
			_height=value;
			drawNow=true;
			invalidate();
		}

		override public function get width():Number {
			return _width;
		}

		override public function set width(value:Number):void {
			_width=value;
			drawNow=true;
			invalidate();
		}

		//=========================================================
		// draw
		//=========================================================
		private function draw():void {
			graphics.clear();

			graphics.beginFill(0xffffff, 0.4);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();

			removeBalls();

			graphics.beginFill(0, 0);
			addBalls();
			graphics.endFill();
		}

		private function addBalls():void {
			if (list !== null && list.length > 0) {

				store=new Vector.<BallSprite>;

				var lineThickness:int=1;
				var lineAlpha:Number=0.1;

				var sp:BallSprite;

				var pid:int;

				var f:int=-1;
				var fmax:int=list.length;

				while (++f < fmax) {
					pid=pool.next();
					sp=pool.get(pid) as BallSprite;
					sp.poolid=pid;
					sp.ball=list[f];
					sp.canvas=this;
					sp.upCallback=up;
					sp.downCallback=down;
					sp.removeCallback=remove;
					sp.watch();
					addChild(sp);

					if (f == 0) {
						graphics.moveTo(sp.x, sp.y);
					} else {
						graphics.lineStyle(lineThickness / 3, 0, lineAlpha, true);
						graphics.lineTo(sp.x, sp.y);

						lineThickness++;
						lineAlpha+=0.1;
					}

					store.push(sp);
				}
			}
		}

		private function removeBalls():void {
			if (store) {
				var f:int=store.length;
				var sp:BallSprite;
				while (--f >= 0) {
					sp=store[f];
					sp.unwatch();
					removeChild(sp);
					pool.put(sp.poolid);
				}

				store=null;
			}
		}

		private function up(ball:Ball):void {
			var evt:BallCanvasEvent=new BallCanvasEvent(BallCanvasEvent.UP_BALL);
			evt.ball=ball;
			dispatchEvent(evt);
		}

		private function down(ball:Ball):void {
			var evt:BallCanvasEvent=new BallCanvasEvent(BallCanvasEvent.DOWN_BALL);
			evt.ball=ball;
			dispatchEvent(evt);
		}

		private function remove(ball:Ball):void {
			var evt:BallCanvasEvent=new BallCanvasEvent(BallCanvasEvent.REMOVE_BALL);
			evt.ball=ball;
			dispatchEvent(evt);
		}

		private function clearAllBalls(event:KeyboardEvent):void {
			if (event.keyCode === Keyboard.ESCAPE) {
				dispatchEvent(new BallCanvasEvent(BallCanvasEvent.REMOVE_ALL));
			}
		}
	}
}
import flash.display.Sprite;
import flash.events.ContextMenuEvent;
import flash.geom.Rectangle;
import flash.text.engine.TextLine;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import flashx.textLayout.compose.TextLineRecycler;
import flashx.textLayout.factory.StringTextLineFactory;
import flashx.textLayout.formats.TextAlign;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.textLayout.formats.VerticalAlign;

import ssen.common.MathUtils;
import ssen.mvc.samples.flash.model.Ball;
import ssen.mvc.samples.flash.view.BallCanvas;

class BallSprite extends Sprite {
	public var poolid:int;
	public var ball:Ball;
	public var canvas:BallCanvas;

	public var upCallback:Function;
	public var downCallback:Function;
	public var removeCallback:Function;

	private var up:ContextMenuItem;
	private var down:ContextMenuItem;
	private var remove:ContextMenuItem;
	private var tl:TextLine;

	public function unwatch():void {
		graphics.clear();

		up.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, upSelect);
		down.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, downSelect);
		remove.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, removeSelect);

		up=null;
		down=null;
		remove=null;
		contextMenu=null;
		ball=null;
		canvas=null;
		upCallback=null;
		downCallback=null;
		removeCallback=null;

		removeChild(tl);
		TextLineRecycler.addLineForReuse(tl);
		tl=null;
	}

	public function watch():void {
		x=ball.x * canvas.width;
		y=ball.y * canvas.height;
		var radius:int=ball.r * (canvas.width / 50);

		graphics.beginFill(MathUtils.rand(0x000000, 0xffffff));
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();

		up=new ContextMenuItem("up");
		down=new ContextMenuItem("down");
		remove=new ContextMenuItem("remove");

		up.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, upSelect, false, 0, true);
		down.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, downSelect, false, 0, true);
		remove.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, removeSelect, false, 0, true);

		var ctx:ContextMenu=new ContextMenu;
		ctx.customItems=[up, down, remove];

		contextMenu=ctx;

		mouseChildren=false;

		var cf:TextLayoutFormat=new TextLayoutFormat;
		cf.textAlign=TextAlign.CENTER;
		cf.verticalAlign=VerticalAlign.MIDDLE;
		cf.color=0xffffff;
		var fac:StringTextLineFactory=new StringTextLineFactory;
		fac.text=ball.id.toString();
		fac.textFlowFormat=cf;
		fac.compositionBounds=new Rectangle(-radius, -radius, radius * 2, radius * 2);
		fac.createTextLines(textCreated);
	}

	private function textCreated(line:TextLine):void {
		tl=line;
		addChild(tl);
	}

	private function removeSelect(event:ContextMenuEvent):void {
		removeCallback(ball);
	}

	private function downSelect(event:ContextMenuEvent):void {
		downCallback(ball);
	}

	private function upSelect(event:ContextMenuEvent):void {
		upCallback(ball);
	}
}

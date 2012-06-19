package ssen.mvc.samples.flash.view {
	import de.polygonal.ds.pooling.ObjectPool;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

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

			pool=new ObjectPool(100);
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
			trace("BallCanvas.doubleClickHandler", event );
			
			var evt:BallCanvasEvent=new BallCanvasEvent(BallCanvasEvent.CREATE_BALL);
			evt.xpos=event.localX / _width;
			evt.ypos=event.localY / _height;

			dispatchEvent(evt);
		}

		//=========================================================
		// public api
		//=========================================================
		public function setBallList(list:Vector.<Ball>):void {
			list=list;
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
			
			trace("BallCanvas.draw",  _width, _height);

			graphics.beginFill(0x000000, 1);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();

			removeBalls();
			addBalls();
		}

		private function addBalls():void {
			if (list !== null && list.length > 0) {
				store=new Vector.<BallSprite>;

				var sp:BallSprite;

				var pid:int;

				var f:int=-1;
				var fmax:int=list.length;
				while (++f < fmax) {
					pid=pool.next();
					sp=pool.get(pid) as BallSprite;
					sp.watch(list[f], this);
					addChild(sp);
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
	}
}
import flash.display.Sprite;

import ssen.common.MathUtils;
import ssen.mvc.samples.flash.model.Ball;
import ssen.mvc.samples.flash.view.BallCanvas;

class BallSprite extends Sprite {
	public var poolid:int;

	public function unwatch():void {
		graphics.clear();
	}

	public function watch(ball:Ball, canvas:BallCanvas):void {
		x=ball.x * canvas.width;
		y=ball.y * canvas.height;
		var radius:int=ball.r * (canvas.width / 100);

		graphics.beginFill(MathUtils.rand(0x000000, 0xffffff), 0.6);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
}

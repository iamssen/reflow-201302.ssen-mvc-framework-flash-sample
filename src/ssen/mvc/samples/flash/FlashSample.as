package ssen.mvc.samples.flash {
	import flash.display.Sprite;
	import flash.events.Event;

	import ssen.mvc.core.IContext;
	import ssen.mvc.core.IContextView;
	import ssen.mvc.samples.flash.view.BallCanvas;

	public class FlashSample extends Sprite implements IContextView {
		private var context:FlashSampleContext;
		private var _height:int;
		private var _width:int;
		private var canvas:BallCanvas;

		public function FlashSample() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		private function addedToStageHandler(event:Event):void {
			trace("ssen.mvc.samples.flash.FlashSample.addedToStageHandler(", event, ")");
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			initialContext();

			canvas=new BallCanvas;
			canvas.width=_width;
			canvas.height=_height;

			addChild(canvas);
		}

		public function deconstruct():void {
			removeChild(canvas);

			canvas.graphics.clear();
			canvas=null;
		}

		public function get contextInitialized():Boolean {
			return context !== null;
		}

		public function initialContext(parentContext:IContext=null):void {
			context=new FlashSampleContext(this, parentContext);
		}

		override public function get height():Number {
			return _height;
		}

		override public function set height(value:Number):void {
			_height=value;

			if (canvas) {
				canvas.height=value;
			}
		}

		override public function get width():Number {
			return _width;
		}

		override public function set width(value:Number):void {
			_width=value;

			if (canvas) {
				canvas.width=value;
			}
		}
	}
}

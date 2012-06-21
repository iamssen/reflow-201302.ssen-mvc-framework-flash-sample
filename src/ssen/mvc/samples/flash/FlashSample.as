package ssen.mvc.samples.flash {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ssen.mvc.core.IContext;
	import ssen.mvc.core.IContextView;
	import ssen.mvc.samples.flash.view.BallCanvas;

	public class FlashSample extends Sprite implements IContextView {
		private var context:FlashSampleContext;
		private var canvas:BallCanvas;
		private var dataid:int;
		private var _height:int;
		private var _width:int;

		/**
		 * constructor
		 * @param dataid 캐시로 사용할 SharedObject 의 id 입니다.
		 */
		public function FlashSample(dataid:int) {
			this.dataid=dataid;

			initialContext();

			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			//---------------------------------------
			// 모든 view 는 context 의 실행 시점 이후에 추가되어야 합니다.
			// 
			// 시점은 constructor 이후면 됩니다
			// 쉽게 이야기해서 constructor 에서 view 를 추가하면 해당 view 는 
			// view catcher 에 의해 catch 되지 않습니다.
			// 즉, mediator 생성, injection 모두 작동되지 않게됩니다
			//
			// mxml 에서는 애초에 constructor 에서 addChild 될 일이 없어서 상관없지만
			// as 를 통해 사용할 경우에는 주의해야 합니다
			//---------------------------------------
			canvas=new BallCanvas;
			canvas.width=_width;
			canvas.height=_height;
			addChild(canvas);
		}

		//=========================================================
		// implements context view
		//=========================================================
		public function get contextInitialized():Boolean {
			return context !== null;
		}

		public function initialContext(parentContext:IContext=null):void {
			context=new FlashSampleContext(dataid, this, parentContext);
		}

		//=========================================================
		// override width height
		//=========================================================
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

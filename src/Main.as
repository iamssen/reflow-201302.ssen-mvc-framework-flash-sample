package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ssen.mvc.samples.flash.FlashSample;

	public class Main extends Sprite {
		private var cview1:FlashSample;
		private var cview2:FlashSample;

		public function Main() {
			//---------------------------------------
			// context view 를 생성합니다
			//---------------------------------------
			cview1=new FlashSample(1);
			cview2=new FlashSample(2);
			addChild(cview1);
			addChild(cview2);

			//---------------------------------------
			// stage size 감시를 시작합니다
			//---------------------------------------
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			//---------------------------------------
			// stage size 가 변경 될 때 마다 context view 의 size 를 변경해 줍니다
			//---------------------------------------
			stage.addEventListener(Event.RESIZE, resizeHandler);
			bindSize();
		}

		private function resizeHandler(event:Event):void {
			bindSize();
		}

		private function bindSize():void {
			cview1.width=stage.stageWidth / 2;
			cview1.height=stage.stageHeight;
			cview1.x=0;
			cview1.y=0;
			cview2.width=stage.stageWidth / 2;
			cview2.height=stage.stageHeight;
			cview2.x=cview1.width;
			cview2.y=0;
		}
	}
}

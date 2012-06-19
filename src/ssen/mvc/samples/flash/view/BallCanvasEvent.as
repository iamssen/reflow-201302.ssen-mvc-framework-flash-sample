package ssen.mvc.samples.flash.view {
	import flash.events.Event;

	internal class BallCanvasEvent extends Event {
		public static const CREATE_BALL:String="createBall";

		public var xpos:Number;
		public var ypos:Number;

		public function BallCanvasEvent(type:String) {
			super(type);
		}

		override public function clone():Event {
			var evt:BallCanvasEvent=new BallCanvasEvent(type);
			evt.xpos=xpos;
			evt.ypos=ypos;

			return evt;
		}

		override public function toString():String {
			return formatToString("BallCanvasEvent", "type", "xpos", "ypos");
		}


	}
}

package ssen.mvc.samples.flash.events {
	import flash.events.Event;

	public class BallEvent extends Event {
		public static const ADD_BALL:String="addBall";
		public static const REMOVE_BALL:String="removeBall";
		public static const UP_BALL:String="upBall";
		public static const DOWN_BALL:String="downBall";
		public static const RENDER_BALL_LIST:String="renderBallList";
		public static const CLEAR_ALL:String="clearAll";

		public var ballId:int;
		public var xpos:Number;
		public var ypos:Number;

		public function BallEvent(type:String) {
			super(type);
		}

		override public function clone():Event {
			var clone:BallEvent=new BallEvent(type);
			clone.ballId=ballId;
			clone.xpos=xpos;
			clone.ypos=ypos;

			return clone;
		}

		override public function toString():String {
			return formatToString("BallEvent", "type", "ballId", "xpos", "ypos");
		}
	}
}

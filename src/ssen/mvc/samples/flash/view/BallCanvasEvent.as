package ssen.mvc.samples.flash.view {
import flash.events.Event;

import ssen.mvc.samples.flash.model.Ball;

//=========================================================
// 보통 view 와 mediator 의 이벤트 전달은 view 에 상수로 기록할 수 있지만,
// 전달해야 할 매개변수가 있을 경우에는 이와 같이 독자적인
// 이벤트를 만들어서 사용할 수 있습니다
//=========================================================
internal class BallCanvasEvent extends Event {
	public static const CREATE_BALL:String="createBall";
	public static const UP_BALL:String="upBall";
	public static const DOWN_BALL:String="downBall";
	public static const REMOVE_BALL:String="removeBall";
	public static const REMOVE_ALL:String="removeAll";

	public var xpos:Number;
	public var ypos:Number;
	public var ball:Ball;

	public function BallCanvasEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		var evt:BallCanvasEvent=new BallCanvasEvent(type);
		evt.xpos=xpos;
		evt.ypos=ypos;
		evt.ball=ball;

		return evt;
	}

	override public function toString():String {
		return formatToString("BallCanvasEvent", "type", "xpos", "ypos", "ball");
	}


}
}

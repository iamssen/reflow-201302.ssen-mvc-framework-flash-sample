package ssen.mvc.samples.flash.controller {
	import flash.events.Event;

	import ssen.mvc.core.ICommand;
	import ssen.mvc.core.IEventBus;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.Ball;
	import ssen.mvc.samples.flash.model.BallModel;

	public class AddBall implements ICommand {
		[Inject]
		public var model:BallModel;

		[Inject]
		public var eventBus:IEventBus;

		public function execute(event:Event=null):void {
			var inputEvt:BallEvent=event as BallEvent;
			var outputEvt:BallEvent;

			model.addBall(inputEvt.xpos, inputEvt.ypos, function(ball:Ball):void {
				outputEvt=new BallEvent(BallEvent.RENDER_BALL_LIST);
				eventBus.dispatchEvent(outputEvt);
			}, function(error:Error):void {

			});
		}
	}
}

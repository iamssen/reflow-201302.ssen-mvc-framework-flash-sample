package ssen.mvc.samples.flash.controller {
	import flash.events.Event;
	
	import ssen.mvc.core.ICommand;
	import ssen.mvc.core.IEventBus;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.BallModel;

	public class UpdateBall implements ICommand {
		[Inject]
		public var model:BallModel;

		[Inject]
		public var eventBus:IEventBus;

		public function execute(event:Event=null):void {
			var inputEvt:BallEvent=event as BallEvent;
			var outputEvt:BallEvent;

			var func:Function;
			if (inputEvt.type === BallEvent.UP_BALL) {
				func=model.upBall;
			} else {
				func=model.downBall;
			}

			func(inputEvt.ballId, function():void {
				outputEvt=new BallEvent(BallEvent.RENDER_BALL_LIST);
				eventBus.dispatchEvent(outputEvt);
			}, function(error:Error):void {

			});
		}
	}
}

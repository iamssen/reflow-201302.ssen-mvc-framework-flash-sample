package ssen.mvc.samples.flash.controller {
	import flash.events.Event;
	
	import ssen.mvc.core.ICommand;
	import ssen.mvc.core.IContextDispatcher;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.BallModel;

	public class RemoveBall implements ICommand {
		[Inject]
		public var model:BallModel;

		[Inject]
		public var dispatcher:IContextDispatcher;

		public function execute(event:Event=null):void {
			var inputEvt:BallEvent=event as BallEvent;
			var outputEvt:BallEvent;

			model.removeBall(inputEvt.ballId, function():void {
				outputEvt=new BallEvent(BallEvent.RENDER_BALL_LIST);
				dispatcher.dispatch(outputEvt);
			}, function(error:Error):void {

			});
		}
	}
}

package ssen.mvc.samples.flash.view {
	import ssen.mvc.core.IContextDispatcher;
	import ssen.mvc.core.IMediator;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.Ball;
	import ssen.mvc.samples.flash.model.BallModel;

	public class BallCanvasMediator implements IMediator {
		[Inject]
		public var dispatcher:IContextDispatcher;

		[Inject]
		public var model:BallModel;

		private var view:BallCanvas;

		public function setView(view:Object):void {
			this.view=view as BallCanvas;
		}

		public function onRegister():void {
			dispatcher.addEventListener(BallEvent.RENDER_BALL_LIST, renderBallList);

			view.addEventListener(BallCanvasEvent.CREATE_BALL, createBall);
		}

		public function onRemove():void {
			dispatcher.removeEventListener(BallEvent.RENDER_BALL_LIST, renderBallList);

			view.removeEventListener(BallCanvasEvent.CREATE_BALL, createBall);

			view.deconstruct();
			view=null;
		}

		private function createBall(event:BallCanvasEvent):void {
			trace("BallCanvasMediator.createBall", event);

			var evt:BallEvent=new BallEvent(BallEvent.ADD_BALL);
			evt.xpos=event.xpos;
			evt.ypos=event.ypos;

			dispatcher.dispatch(evt);
		}

		private function renderBallList(event:BallEvent):void {
			model.getBallList(function(list:Vector.<Ball>):void {
				trace("BallCanvasMediator.enclosing_method", list);
				view.setBallList(list);
			}, function(error:Error):void {
				trace("BallCanvasMediator.enclosing_method", error);
			});
		}
	}
}

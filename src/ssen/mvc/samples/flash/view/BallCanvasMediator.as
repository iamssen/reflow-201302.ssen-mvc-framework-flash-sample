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
			view.addEventListener(BallCanvasEvent.UP_BALL, upBall);
			view.addEventListener(BallCanvasEvent.DOWN_BALL, downBall);
			view.addEventListener(BallCanvasEvent.REMOVE_BALL, removeBall);
			view.addEventListener(BallCanvasEvent.REMOVE_ALL, removeAll);

			renderBallList();
		}

		public function onRemove():void {
			dispatcher.removeEventListener(BallEvent.RENDER_BALL_LIST, renderBallList);

			view.removeEventListener(BallCanvasEvent.CREATE_BALL, createBall);
			view.removeEventListener(BallCanvasEvent.UP_BALL, upBall);
			view.removeEventListener(BallCanvasEvent.DOWN_BALL, downBall);
			view.removeEventListener(BallCanvasEvent.REMOVE_BALL, removeBall);
			view.removeEventListener(BallCanvasEvent.REMOVE_ALL, removeAll);

			view.deconstruct();
			view=null;
		}

		private function removeAll(event:BallCanvasEvent):void {
			var evt:BallEvent=new BallEvent(BallEvent.CLEAR_ALL);
			dispatcher.dispatch(evt);
		}

		private function removeBall(event:BallCanvasEvent):void {
			var evt:BallEvent=new BallEvent(BallEvent.REMOVE_BALL);
			evt.ballId=event.ball.id;
			dispatcher.dispatch(evt);
		}

		private function downBall(event:BallCanvasEvent):void {
			var evt:BallEvent=new BallEvent(BallEvent.DOWN_BALL);
			evt.ballId=event.ball.id;
			dispatcher.dispatch(evt);
		}

		private function upBall(event:BallCanvasEvent):void {
			var evt:BallEvent=new BallEvent(BallEvent.UP_BALL);
			evt.ballId=event.ball.id;
			dispatcher.dispatch(evt);
		}

		private function createBall(event:BallCanvasEvent):void {
			var evt:BallEvent=new BallEvent(BallEvent.ADD_BALL);
			evt.xpos=event.xpos;
			evt.ypos=event.ypos;

			dispatcher.dispatch(evt);
		}

		private function renderBallList(event:BallEvent=null):void {
			model.getBallList(function(list:Vector.<Ball>):void {
				view.setBallList(list);
			}, function(error:Error):void {
				trace("BallCanvasMediator.enclosing_method", error);
			});
		}
	}
}

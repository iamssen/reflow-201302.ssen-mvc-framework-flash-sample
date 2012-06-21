package ssen.mvc.samples.flash.view {
	import ssen.mvc.core.IContextDispatcher;
	import ssen.mvc.core.IMediator;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.Ball;
	import ssen.mvc.samples.flash.model.BallModel;


	//=========================================================
	// Mediator 는 "중재자" 라는 의미를 지닙니다
	// 말 그대로 단순한 "출력 기능" 만 지녀야 하는 (그래야 재활용을 하던 말던...)
	// View 와 Model, Controller 기능들을 중재해 줍니다
	//=========================================================
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
			// 외부 로직에서 들어오는 요청을 감시합니다 
			dispatcher.addEventListener(BallEvent.RENDER_BALL_LIST, renderBallList);

			// View 에서 발생되는 User 의 요청을 감시합니다
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

		//=========================================================
		// User 의 요청을 처리하도록 알립니다
		// Mediator 에서는 어떤 처리를 함으로서 "중재자" 본연의 기능 이상을
		// 처리하지 않도록 하는 것이 좋습니다. (처리가 가능하게 되어 있긴하지만...)
		//=========================================================
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

		//=========================================================
		// 로직의 요청을 받아들여서 View 에 반영되도록 해줍니다
		//=========================================================
		private function renderBallList(event:BallEvent=null):void {
			model.getBallList(function(list:Vector.<Ball>):void {
				view.setBallList(list);
			}, function(error:Error):void {
				trace("BallCanvasMediator.enclosing_method", error);
			});
		}
	}
}

package ssen.mvc.samples.flash {
	import ssen.mvc.core.IContext;
	import ssen.mvc.core.IContextView;
	import ssen.mvc.ondisplay.DisplayContext;
	import ssen.mvc.samples.flash.controller.AddBall;
	import ssen.mvc.samples.flash.controller.ClearAllBalls;
	import ssen.mvc.samples.flash.controller.RemoveBall;
	import ssen.mvc.samples.flash.controller.UpdateBall;
	import ssen.mvc.samples.flash.events.BallEvent;
	import ssen.mvc.samples.flash.model.BallModel;
	import ssen.mvc.samples.flash.model.CacheBallModel;
	import ssen.mvc.samples.flash.view.BallCanvas;
	import ssen.mvc.samples.flash.view.BallCanvasMediator;

	public class FlashSampleContext extends DisplayContext {
		private var dataid:int;

		public function FlashSampleContext(dataid:int, contextView:IContextView, parentContext:IContext=null) {
			this.dataid=dataid;
			super(contextView, parentContext);
		}

		override protected function mapDependency():void {
			viewInjector.mapView(BallCanvas, BallCanvasMediator);

			//---------------------------------------
			// ball model 과 같이 생성시에 parameter 전달이 필요한 경우에는
			// instance 를 직접 생성하고, mapValue 형태로 mapping 시킬 수 있습니다
			//---------------------------------------
			injector.mapValue(BallModel, new CacheBallModel(dataid));

			commandMap.mapCommand(BallEvent.ADD_BALL, AddBall);
			commandMap.mapCommand(BallEvent.UP_BALL, UpdateBall);
			commandMap.mapCommand(BallEvent.DOWN_BALL, UpdateBall);
			commandMap.mapCommand(BallEvent.REMOVE_BALL, RemoveBall);
			commandMap.mapCommand(BallEvent.CLEAR_ALL, ClearAllBalls);
		}
	}
}

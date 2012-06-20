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
		public function FlashSampleContext(contextView:IContextView, parentContext:IContext=null) {
			super(contextView, parentContext);
		}

		override protected function mapDependency():void {
			viewInjector.mapView(BallCanvas, BallCanvasMediator);

			injector.mapSingletonOf(BallModel, CacheBallModel);

			commandMap.mapCommand(BallEvent.ADD_BALL, AddBall);
			commandMap.mapCommand(BallEvent.UP_BALL, UpdateBall);
			commandMap.mapCommand(BallEvent.DOWN_BALL, UpdateBall);
			commandMap.mapCommand(BallEvent.REMOVE_BALL, RemoveBall);
			commandMap.mapCommand(BallEvent.CLEAR_ALL, ClearAllBalls);
		}

	}
}

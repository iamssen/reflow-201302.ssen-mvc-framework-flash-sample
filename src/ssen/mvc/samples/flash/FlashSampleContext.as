package ssen.mvc.samples.flash {
	import ssen.mvc.core.IContext;
	import ssen.mvc.core.IContextView;
	import ssen.mvc.ondisplay.DisplayContext;
	import ssen.mvc.samples.flash.controller.AddBall;
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
		}

		override protected function shutdown():void {
			// TODO Auto Generated method stub
			super.shutdown();
		}

		override protected function startup():void {
			// TODO Auto Generated method stub
			super.startup();
		}

	}
}

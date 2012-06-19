package ssen.mvc.samples.flash.model {

	public interface BallModel {
		function addBall(x:Number, y:Number, result:Function=null, fault:Function=null):void;
		function removeBall(id:int, result:Function=null, fault:Function=null):void;
		function upBall(id:int, result:Function=null, fault:Function=null):void;
		function downBall(id:int, result:Function=null, fault:Function=null):void;
		function getBallList(result:Function=null, fault:Function=null):void;
		function clearBallList(result:Function=null, fault:Function=null):void;
	}
}

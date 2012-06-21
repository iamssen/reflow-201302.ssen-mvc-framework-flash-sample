package ssen.mvc.samples.flash.model {

	//=========================================================
	// ball 에 대한 data 를 다루는 Service model 입니다
	//=========================================================
	public interface BallModel {
		function addBall(x:Number, y:Number, result:Function=null, fault:Function=null):void;
		function removeBall(id:int, result:Function=null, fault:Function=null):void;
		function upBall(id:int, result:Function=null, fault:Function=null):void;
		function downBall(id:int, result:Function=null, fault:Function=null):void;
		function getBallList(result:Function=null, fault:Function=null):void;
		function clearBallList(result:Function=null, fault:Function=null):void;
	}
}

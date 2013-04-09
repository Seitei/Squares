package utils
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class Movement
	{
		private static const DEGREE:Number = Math.PI / 180;
		private var _aDegree:Number;
		private var _instance:Movement;
		private var _init:Boolean = false;
		private var _rallyPointX:Number;
		private var _rallyPointY:Number;
		private var _midPointX:Number;
		private var _midPointY:Number;
		private var _maximumRotation:Number;
		
		private var _reachedX:Boolean;
		private var _reachedY:Boolean;
		private var _reachedMaxRot:Boolean;
		private var _speed:Number;
		private var _finalXIncrement:Number;
		private var _finalYIncrement:Number;
		private var _angleShift:Number;
		private var _rotationDirection:int;
		private var _maximumSpeed:Number = 1;
		
		public function Movement()
		{
			_speed = 0.1;
			_aDegree = DEGREE / 5;
		}	
		
		
		public function carLikeMove(obj:Object, rallyPoint:Point):Boolean {
			
			if(!(_init)){
				_init = true;
				var initDiff:Point = rallyPoint.subtract(new Point(obj.x, obj.y));
				var initAngle:Number = Math.atan2(initDiff.y, initDiff.x);
				//if(_rotationDirection
				
				if(initAngle <= 0 && initAngle >= -45 * DEGREE){
					_rotationDirection = -1;
					_angleShift = 0;
				}
				
				if(initAngle < -45 * DEGREE && initAngle >= -90 * DEGREE){
					_rotationDirection = 1;
					_angleShift = -90 * DEGREE;
				}
				
				if(initAngle < -90 * DEGREE && initAngle >= -135 * DEGREE){
					_rotationDirection = -1;					
					_angleShift = -90 * DEGREE;
				}
				
				if(initAngle < -135 * DEGREE && initAngle >= -180 * DEGREE){
					_rotationDirection = 1;					
					_angleShift = -180 * DEGREE;
				}
				
				if(initAngle > 0 * DEGREE && initAngle <= 45 * DEGREE){
					_rotationDirection = 1;					
					_angleShift = 0;
				}
				
				if(initAngle > 45 * DEGREE && initAngle <= 90 * DEGREE){
					_rotationDirection = -1;					
					_angleShift = 90 * DEGREE;
				}
				
				if(initAngle > 90 * DEGREE && initAngle <= 135 * DEGREE){
					_rotationDirection = 1;					
					_angleShift = 90 * DEGREE;
				}
				
				if(initAngle > 135 * DEGREE && initAngle <= 180 * DEGREE){
					_rotationDirection = -1;					
					_angleShift = 180 * DEGREE;
				}
			}
			
			var diff:Point = rallyPoint.subtract(new Point(obj.x, obj.y)); 
			var dist:Number = diff.length;
			
			if (dist <= _speed)
			{
				obj.x = rallyPoint.x;
				obj.y = rallyPoint.y;
				return true;
			}
			
			
			
			if(_rotationDirection * (obj.rotation + _angleShift) >= _rotationDirection * (Math.atan2(diff.y, diff.x)) && !_reachedMaxRot) {
				trace("obj: " + obj.rotation);
				_reachedMaxRot = true;
				obj.rotation = Math.atan2(diff.y, diff.x) - _angleShift; 
				_maximumRotation = obj.rotation;
				_finalXIncrement = Math.cos(_maximumRotation + _angleShift);
				_finalYIncrement = Math.sin(_maximumRotation + _angleShift);
			}
			
			if(!_reachedMaxRot) {
				obj.rotation += _aDegree * _rotationDirection;
				moveInDirection(obj, obj.rotation, _speed);
				_aDegree += _aDegree / 500;
			}
			else {
				moveInFixedDirection(obj, _finalXIncrement, _finalYIncrement, _speed);
			}
			
			if(_speed >= _maximumSpeed)
				_speed = _maximumSpeed;
			else
				_speed += 0.01;
			
			if(_reachedMaxRot && _reachedX && _reachedY)
				return true;
			else
				return false
			
		}
		
		private function moveInDirection(obj:Object, angle:Number, speed:Number):void {
			obj.x += Math.cos(angle + _angleShift) * speed;
			obj.y += Math.sin(angle + _angleShift) * speed;
		}
		
		private function moveInFixedDirection(obj:Object, xIncrement:Number, yIncrement:Number, speed:Number):void {
			
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			obj.x += xIncrement * _speed;
			obj.y += yIncrement * _speed;
			
		}
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
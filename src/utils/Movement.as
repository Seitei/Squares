package utils
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class Movement
	{
		private var _instance:Movement;
		private var _originalValue:Object;
		private var _finalValue:Object;
		
		private var _reachedX:Boolean;
		private var _reachedY:Boolean;
		private var _reachedRot:Boolean;
		
		public function Movement()
		{
			
		}	
		
		public function moveToPoint(obj:Object, time:Number, finalValue:Point, totalTime:Number):Boolean
		{
			if(!(_originalValue)){
				_originalValue = {"x": obj.x, "y": obj.y};
			}
			
			if(obj.x == finalValue.x && !_reachedX)
				_reachedX = true;				
			
			if(!_reachedX) obj.x = noEasing(time, _originalValue.x, finalValue.x - _originalValue.x, totalTime);
			
			if(obj.y == finalValue.y && !_reachedY)
				_reachedY = true;			
			
			if(!_reachedY) obj.y = noEasing(time, _originalValue.y, finalValue.y - _originalValue.y, totalTime);
			
			if(_reachedX && _reachedY)
				return true;
			else
				return false
			
			
		}
		
		
		
		
		public function carLikeMove(obj:Object, time:Number, finalValue:Point, totalTime:Number):Boolean {
			
			if(!(_originalValue)){
				_originalValue = {"x": obj.x, "y": obj.y, "rotation": obj.rotation};
				var diff:Point = finalValue.subtract(new Point(obj.x, obj.y)); 
				_finalValue = {"rotation": Math.atan2(diff.y, diff.x) + 90 * (Math.PI / 180)};
			}
			
			if(obj.rotation == _finalValue.rotation && !_reachedRot)
				_reachedRot = true;
			
			if(!_reachedRot) obj.rotation = easeInOutCubic(time, _originalValue.rotation, _finalValue.rotation - _originalValue.rotation, totalTime);
			
			if(obj.x == finalValue.x && !_reachedX)
				_reachedX = true;				
			
			if(!_reachedX) obj.x = easeInOutCubic(time, _originalValue.x, finalValue.x - _originalValue.x, totalTime);
			
			if(obj.y == finalValue.y && !_reachedY)
				_reachedY = true;			
			
			if(!_reachedY) obj.y = easeInOutCubic(time, _originalValue.y, finalValue.y - _originalValue.y, totalTime);
			
			
			if(_reachedRot && _reachedX && _reachedY)
				return true;
			else
				return false
			
		}
		
		
		
		private function noEasing(t:Number, b:Number, c:Number, d:Number):Number {
			return c * t / d + b;
		}
		
		private function easeInCubic(t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t)*t*t + b;
		}
		
		private function easeInOutCubic(t:Number, b:Number, c:Number, d:Number):Number {
			
			if ((t = t/(d/2)) < 1) return c/2*t*t*t + b;
				return c/2*((t-=2)*t*t + 2) + b;
		}
		
		private function easeOutCubic(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c*((t=t/d-1)*t*t + 1) + b;
		}
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
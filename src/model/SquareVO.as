package model
{
	public class SquareVO extends EntityVO
	{
		private var _squareType:String;
		private var _relativePositionX:Number;
		private var _relativePositionY:Number;
		
		public function SquareVO(posX:int, posY:int)
		{
			super("square");
			x = posX;
			y = posY;
			
		}

		public function get squareType():String
		{
			return _squareType;
		}

		public function set squareType(value:String):void
		{
			_squareType = value;
		}
		
		public function get relativePositionY():Number
		{
			return _relativePositionY;
		}
		
		public function set relativePositionY(value:Number):void
		{
			_relativePositionY = value;
		}
		
		public function get relativePositionX():Number
		{
			return _relativePositionX;
		}
		
		public function set relativePositionX(value:Number):void
		{
			_relativePositionX = value;
		}

	}
}
package model
{
	import flash.geom.Point;

	public class SquareVO
	{
		private var _entityId:String;
		private var _type:String;
		private var _status:String;
		private var _relativePosition:Point;
		
		public function SquareVO(type:String, relativePosition:Point)
		{
			_type = type;
			_relativePosition = relativePosition;
		}

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}

		public function get entityId():String
		{
			return _entityId;
		}

		public function set entityId(value:String):void
		{
			_entityId = value;
		}

		public function get relativePosition():Point
		{
			return _relativePosition;
		}

		public function set relativePosition(value:Point):void
		{
			_relativePosition = value;
		}

		public function get type():String
		{
			return _type;
		}

	}
}
package model
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	public class EntityVO
	{
		private static const SQUARE_SIZE:int = 9;
		private static const SEP:int = 1;

		private var _x:Number;
		private var _y:Number;
		private var _position:Point;
		private var _type:String;
		private var _id:String;
		private var _status:String;
		private var _owner:String;
		private var _rotation:Number;
		private var _rallypoint:Point;
		private var _positionDest:Point;
		private var _level:int;
		private var _data:Array;
		private var _squaresData:Vector.<SquareVO>;
		
		public function EntityVO()
		{
			position = new Point();
			_rotation = 0;
			initData();
			_squaresData = new Vector.<SquareVO>;
		}
		
		//default value for the matrix data
		private function initData():void {
			
			_data = new Array();
			_data[0] = "squareCenteredMode";
			_data[1] = [[0, 0, 0, 0, 0, 0, 0], 
						[0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0],
						[0, 0, 0, 0, 0, 0, 0]];
		}
		
		public function get squaresData():Vector.<SquareVO>
		{
			return _squaresData;
		}

		public function set squaresData(value:Vector.<SquareVO>):void
		{
			_squaresData = value;
		}

		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			arrangeSquares();
		}

		private function arrangeSquares():void {
			
			for(var i:int = 0; i < _data[1].length; i++) {
				
				for(var j:int = 0; j < _data[1][i].length; j++) {
				
					if(_data[1][i][j] != 0){
						
						var point:Point = new Point();
						
						if(_data[0] == "vertexCenteredMode"){
							point.x = i * (SQUARE_SIZE + SEP) - (SQUARE_SIZE + SEP) * 4;
							point.y = j * (SQUARE_SIZE + SEP) - (SQUARE_SIZE + SEP) * 4;
						}
						else {
							point.x = i * (SQUARE_SIZE + SEP) - (SQUARE_SIZE + SEP) * 4;
							point.y = j * (SQUARE_SIZE + SEP) - (SQUARE_SIZE + SEP) * 4;
						}
						
						_squaresData.push(new SquareVO(_data[1][i][j], point));
						
					}
				}
			}
		}
		
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get level():int
		{
			return _level;
		}
		
		public function set applyLevel(level:int):void {
			
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get positionDest():Point
		{
			return _positionDest;
		}

		public function set positionDest(value:Point):void
		{
			_positionDest = value;
		}

		public function get rallypoint():Point
		{
			return _rallypoint;
		}

		public function set rallypoint(value:Point):void
		{
			_rallypoint = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function loop(behaviorReqsContent:Array):void {
			
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
		}

		public function get owner():String
		{
			return _owner;
		}

		public function set owner(value:String):void
		{
			_owner = value;
		}

		public function get status():String
		{
			return _status;
		}

		public function set status(value:String):void
		{
			_status = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get position():Point
		{
			return _position;
		}

		public function set position(value:Point):void
		{
			_position = value;
		}

		
	}
}
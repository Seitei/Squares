package model
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import managers.GameManager;
	
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	import utils.Movement;
	
	import view.Renderer;
	
	public class EntityVO
	{
		private static const SQUARE_SIZE:int = 9;
		private static const SEP:int = 1;

		private var _x:Number;
		private var _y:Number;
		private var _type:String;
		private var _id:String;
		private var _status:String;
		private var _owner:String;
		private var _rotation:Number;
		private var _rallypoint:Point;
		private var _level:int;
		private var _data:Array;
		private var _squaresData:Vector.<SquareVO>;
		private var _active:Boolean;
		private var _behavior:Array;
		private var _speed:Number;
		
		public function EntityVO()
		{
			_rotation = 0;
			initData();
			_squaresData = new Vector.<SquareVO>;
			_behavior = new Array();
		}
		
		//default value for the matrix data

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get behavior():Array
		{
			return _behavior;
		}

		public function set behavior(value:Array):void
		{
			_behavior = value;
		}

		public function get active():Boolean
		{
			return _active;
		}

		public function set active(value:Boolean):void
		{
			_active = value;
		}

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

		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
			createSquares();
		}

		private function createSquares():void {
			
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

		public function get rallypoint():Point
		{
			return _rallypoint;
		}

		public function setRallypoint(value:Point):void
		{
			_rallypoint = value;
			behavior.push(move);
		}

		public function get y():Number
		{
			return _y;
		}
		
		public function move():void {
			if(!Movement.moveToPoint(this, rallypoint, speed)){
				behavior.splice(behavior.indexOf(move, 0), 1);
				return;
			}
			updateGraphics();
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

		public function loop():void {
			
			if(behavior.length == 0)
				GameManager.getInstance().activateEntity(this, false);
					
			for each(var foo:Function in behavior){
				foo();
			}
		}
		
		public function updateGraphics():void {
			Renderer.getInstance().updateEntity(this);
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
	}
}
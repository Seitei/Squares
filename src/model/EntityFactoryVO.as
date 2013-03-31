package model
{
	import flash.geom.Point;
	
	import managers.Manager;
	
	import starling.display.Sprite;
	
	import utils.UnitStatus;

	public class EntityFactoryVO
	{
		private static const BOT:int = 1;
		private static const TOP:int = 0;
		
		private static var _instance:EntityFactoryVO;
		private var _counter:int = 0;
		private var _playerName:String;
		
		public function EntityFactoryVO():void
		{
		}
		
		public function get playerName():String
		{
			return _playerName;
		}

		public function set playerName(value:String):void
		{
			_playerName = value;
		}
		
		public function makeEntity(player:String, type:String, tier:int, positionX:int = 0, positionY:int = 0):EntityVO {
			
			var entity:EntityVO;
			
			switch(type){
				
				case "square":
					entity = new SquareVO(positionX, positionY);		
					break;
				
				case "core":
					entity = new CoreVO(positionX, positionY);		
					break;
				
				case "tower":
					entity = new TowerVO(positionX, positionY);		
					break;
				
				case "unit":
					entity = new UnitVO(positionX, positionY);		
					break;
				
				case "spawner":
					entity = new SpawnerVO(positionX, positionY);		
					break;
			}
			
			_counter ++;
			entity.owner = player;
			entity.id = player + _counter;
			
			return entity;	
		}
		
		public static function getInstance():EntityFactoryVO {
			if(!_instance)
				_instance = new EntityFactoryVO();
			return _instance;
		}
	}
}
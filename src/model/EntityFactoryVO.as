package model
{
	import flash.geom.Point;
	
	import managers.Manager;
	
	import starling.display.Sprite;
	
	import utils.UnitStatus;

	public class EntityFactoryVO extends EntityVO
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
		
		public function makeEntity(player:String, type:String, tier:int, position:Point = null):EntityVO {
			
			var entity:EntityVO;
			
			if(!position) 
				position = new Point();
			
			switch(type){
				
				case "core":
					entity = new CoreVO(position.x, position.y);		
					break;
				
				case "tower":
					entity = new TowerVO(position.x, position.y);		
					break;
				
				case "unit":
					entity = new UnitVO(position.x, position.y);		
					break;
				
				case "spawner":
					entity = new SpawnerVO(position.x, position.y);		
					break;
			}
			
			entity.status = "building";
			
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
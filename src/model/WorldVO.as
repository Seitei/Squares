package model
{
	import flash.geom.Point;
	import flash.media.ID3Info;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;

	public class WorldVO
	{
		//refers to the position to place the tiles
		private static const BOT:int = 0;
		private static const TOP:int = 1;
		
		private var _x:Number;
		private var _y:Number;
		private var _skinClass:String;
		private var _speed:Number = 1;
		public var type:String = "unit";
		private static var _instance:WorldVO;
		private var _entitiesDic:Dictionary;
		private var _entitiesArray:Vector.<EntityVO>;
		private var _entitiesSubgroupsDic:Dictionary;
		private var _unitsArray:Dictionary;
		private var _buildingsArray:Dictionary;
		private var _bulletsArray:Dictionary;
		private var _playersNamesArray:Array;
		
		private var _counter:int = 0; 
		
		public function WorldVO()
		{
			_entitiesDic = new Dictionary();
			_entitiesArray = new Vector.<EntityVO>;
			
			_entitiesSubgroupsDic = new Dictionary();
			
			_playersNamesArray = new Array();
		}

		public function get entitiesDic():Dictionary
		{
			return _entitiesDic;
		}

		public function updateEntity(entity:EntityVO, property:String, value:*, activate:Boolean):void {
			
			activateEntity(entity, activate);
			_entitiesDic[entity.id][property](value);
			
		}
		
		public function activateEntity(entity:EntityVO, activate:Boolean):void {
			if(_entitiesDic[entity.id].active != activate){
				if(activate){
					_entitiesSubgroupsDic["all" + "_active_entities"].push(entity);
				}
				else{
					_entitiesSubgroupsDic["all" + "_active_entities"].splice(_entitiesSubgroupsDic["all" + "_active_entities"].indexOf(entity, 0), 1);
				}
				_entitiesDic[entity.id].active = activate;
			}
		}
		
		private function createSubgroupVectors(owner:String):void {
			if((owner != _playersNamesArray[0] || _playersNamesArray.length == 0)){
				_playersNamesArray.push(owner);
				_entitiesSubgroupsDic[owner] = new Vector.<EntityVO>;
				_entitiesSubgroupsDic[owner + "_attackable_entities"] = new Vector.<EntityVO>;
				_entitiesSubgroupsDic[owner + "_core_entities"] = new Vector.<EntityVO>;
				_entitiesSubgroupsDic["all" + "_active_entities"] = new Vector.<EntityVO>;
			}
		}
		
		public function addEntity(entity:EntityVO):void {
			
			if(_playersNamesArray.length < 2){
				createSubgroupVectors(entity.owner);
			}
			
			_entitiesSubgroupsDic[entity.owner].push(entity);
			
			
			
			if(entity.type == "core"){
				_entitiesSubgroupsDic[entity.owner + "_core_entities"].push(entity);
			}
			
			_entitiesArray.push(entity);
			_entitiesDic[entity.id] = entity;	
				
			
		}
		
		public function removeEntity(entity:EntityVO):void {
			
			_entitiesDic[entity.id] = null;
			_entitiesArray.splice(_entitiesArray.indexOf(entity, 0), 1);
			
			for each(var entityVector:Vector.<EntityVO> in _entitiesSubgroupsDic){
				
				if(entityVector.indexOf(entity, 0) != -1)
					entityVector.splice(entityVector.indexOf(entity, 0), 1);
			}
		}
		
		private function getEnemyName(owner:String):String {
			if(_playersNamesArray[0] == owner)
				return _playersNamesArray[1];
			else
				return _playersNamesArray[0];
		}
		
		public function getEntitiesSubgroup(subgroup:String, owner:String):Vector.<EntityVO> {
			
			switch(subgroup) {
				case "enemy_entities":
					return _entitiesSubgroupsDic[getEnemyName(owner)];
					break;
			
				case "ally_entities":
					return _entitiesSubgroupsDic[owner];
					break;
				
				case "enemy_attackable_entities":
					return _entitiesSubgroupsDic[getEnemyName(owner) + "_attackable_entities"];
					break;
				
				case "ally_core_entities":
					return _entitiesSubgroupsDic[owner + "_core_entities"];
					break;
				
				case "active_entities":
					return _entitiesSubgroupsDic["all" + "_active_entities"];
					break;
				
				default:
					return null;
					break;
			}
		}
		
		public function getEntity(id:String):EntityVO {
			return _entitiesDic[id];
		}
		
		public function getEntities():Vector.<EntityVO> {
			return _entitiesArray;
		}
		
		public static function getInstance():WorldVO {
			if ( !_instance)
				_instance = new WorldVO();
			return _instance;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
package managers
{
	import actions.Action;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	
	import model.EntityVO;
	import model.WorldVO;
	
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	import utils.GameStatus;
	import utils.Movement;
	import utils.MovieClipContainer;
	import utils.UnitStatus;
	
	import view.SpriteEntity;

	public class GameManager
	{
		private static var _instance:GameManager;
		private var _state:int;
		private var _entities:Array;
		private var _world:WorldVO;
		private var _playerName:String;
		private var _entitiesSubgroupsDic:Dictionary;
		
		public function GameManager()
		{
			_entities = new Array();
			_state = GameStatus.STOPPED;
			_world = WorldVO.getInstance();
			_entitiesSubgroupsDic = new Dictionary();
		}
		
		public function get world():WorldVO {
			return _world;
		}
		
		public function get playerName():String
		{
			return _playerName;
		}

		public function set playerName(value:String):void
		{
			_playerName = value;
			_world.playerName = _playerName;
		}

		public function updateWorld(action:Action):void {
			switch(action.type) {
				case "addEntity":
					renderEntity(action.entity);
					_world.addEntity(action.entity);
					break;
				case "sell":
					removeEntity(action.entity);
					break;
				case "setRallypoint":
					_world.updateEntity(action.entity, "rallypoint", action.entity.rallypoint );
					break;
				case "upgrade":
					_world.updateEntity(action.entity, "applyLevel", action.entity.level + 1);
					renderEntity(action.entity);
					break;
			}
		}
		
		//here I receive the other's players actions
		public function updatePlayersWorld(buffer:Vector.<Action>):void {
			
			
			for each ( var action:Action in buffer) {
	
				if(action.entity){
					action.entity.position.x = 700 - action.entity.position.x;
					action.entity.position.y = 700 - action.entity.position.y;
				}
				
				if(action.type == "addEntity"){
					action.entity.rotation += 180 * (Math.PI / 180);
					
					if(action.entity.rallypoint) {
						action.entity.rallypoint.x = 700 -action.entity.rallypoint.x;
						action.entity.rallypoint.y = 700 -action.entity.rallypoint.y;
					}
				}
				if(action.type == "setRallypoint"){
					action.entity.rallypoint.x = 700 - action.entity.rallypoint.x;
					action.entity.rallypoint.y = 700 - action.entity.rallypoint.y;
					//Manager.getInstance().getUI().showRallyPoint(action.entity.position, action.entity.rallypoint, SlotPlacementGuide.getInstance().getInvertedRow(action.target.row), "last");
				}
				
				updateWorld(action);
			}
		}
		
		private function renderEntities():void {
			var entities:Vector.<EntityVO> = new Vector.<EntityVO>;
			entities = _world.getEntities();
			for each (var ent:EntityVO in entities) {
				renderEntity(ent);	
			}
		}
		
		public function loop():void {
			if (_state == GameStatus.PLAYING || _state == GameStatus.COUNTDOWN_PLAYING)
				updateEntities();	
		}
		
		private function getEntitiesSubgroup(reqs:Array, owner:String):Array {
			
			var entitiesSubgroup:Array = new Array();
			
			for(var i:int = 0; i < reqs.length; i++){
				entitiesSubgroup.push(_world.getEntitiesSubgroup(reqs[i], owner));
			}
			
			return entitiesSubgroup;
		}
		
		private function updateEntities():void {
			var spriteEntities:Dictionary = Main.getInstance().getRenderer().getSpriteEntitiesDic();
			//we only consider the loopable entities
			var entities:Vector.<EntityVO> = _world.getEntitiesSubgroup("loopable_entities");
			
			for each (var ent:EntityVO in entities) {
					
				//ent.loop(getEntitiesSubgroup(ent.behaviorReqs, ent.owner));
					
					
				
				
				//detect if another unit is in range
				/*if(ent is ITargeter && ent.status != UnitStatus.BUILDING) {
					(ent).canSpawn = false;
					for each(var target:EntityVO in entities) {
						if(target is ITargeteable && ent.owner != target.owner) {
							var entPoint:Point = ent.position.clone();
							var targetPoint:Point = target.position.clone();
							var dist:Number = Point.distance(entPoint, targetPoint);
							if(dist < ITargeter(ent).targetRange){
								(ent).canSpawn = true;
								(ent).rallypoint = targetPoint;
								break;
							}
						}
					}
				}*/
					
				
			}
		}
		
		public function set state(state:int):void {
			_state = state;
		}
		
		
		private function renderEntity(ent:EntityVO):void {
			Main.getInstance().getRenderer().renderEntity(ent);
		}
		
		public function removeEntity(ent:EntityVO):void {
			_world.removeEntity(ent);
			Main.getInstance().getRenderer().removeEntity(ent.id);
		}
		
		public static function getInstance():GameManager {
			if( _instance == null )
				_instance = new GameManager();
			return _instance;
		}
	
		
		
		
		
		
	}	
}
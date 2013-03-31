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
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
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
		}

		public function updateWorld(action:Action):void {
			switch(action.type) {
				case "addEntity":
					renderEntity(action.entity);
					_world.addEntity(action.entity);
					break;
				case "setRallypoint":
					_world.updateEntity(action.entity, "rallypoint", action.entity.rallypoint, true);
					break;
				case "upgrade":
					_world.updateEntity(action.entity, "applyLevel", action.entity.level + 1, false);
					renderEntity(action.entity);
					break;
				case "issueEntity":
					action.target = _world.getEntitiesSubgroup("ally_core_entities", _playerName)[0];
					_world.updateEntity(action.target, "issueEntity", action.entity, true);
			}
		}
		
		public function addEntity(entity:EntityVO):void {
			renderEntity(entity);
			_world.addEntity(entity);
		}
		
		//here I receive the other's players actions
		public function updatePlayersWorld(buffer:Vector.<Action>):void {
			
			
			for each ( var action:Action in buffer) {
	
				if(action.entity){
					action.entity.x = 700 - action.entity.x;
					action.entity.y = 700 - action.entity.y;
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
			
			//we only consider the active entities
			var activeEntities:Vector.<EntityVO> = _world.getEntitiesSubgroup("active_entities", "all");
			
			for each (var ent:EntityVO in activeEntities) {
					
							
				ent.loop();
				
			
			}
		}
		
		public function activateEntity(entity:EntityVO, activate:Boolean):void {
			_world.activateEntity(entity, activate);
		}
		
		public function updateEntity(entity:EntityVO, property:String, value:*, activate:Boolean):void {
			_world.updateEntity(entity, property, value, activate); 
		}
		
		public function enterCores():void {
			for each(var entity:EntityVO in _world.getEntitiesSubgroup("ally_core_entities", _playerName)){
				_world.updateEntity(entity, "setRallypoint", new Point(550, 450), true);   
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
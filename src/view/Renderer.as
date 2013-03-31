package view
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import managers.Manager;
	
	import model.EntityVO;
	import model.SquareVO;
	
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import utils.MovieClipContainer;
	import utils.ResourceManager;
	import utils.UnitStatus;

	public class Renderer extends Sprite
	{
		private static const BOT:int = 1;
		private static const TOP:int = 0;
		private static var BGSPEED:Number = 0.5;
		
		private static var _instance:Renderer;
		private var _manager:Manager;
		private var _spriteEntityDic:Dictionary;
		private var _playerName:String;
		private var _stateChangeRelatedAnimationsDic:Dictionary;
		private var _hoveredEntity:MovieClipContainer;
		private var _bgContainer:Sprite;
		private var _myCore:Sprite;
		private var _enemyCore:Sprite;
		private var _tilesArray:Array;
		private var _squaresArray:Array;
		private var _pivotX2:Number = 0;
		private var _pivotY2:Number = 0;
		
		public function Renderer()
		{
			_spriteEntityDic = new Dictionary();
			_stateChangeRelatedAnimationsDic = new Dictionary();
			_manager = Manager.getInstance();
			_bgContainer = new Sprite();
			_bgContainer.touchable = false;
			_tilesArray = new Array();
			addChild(_bgContainer);
			_squaresArray new Array();
		}
		
		public function set playerName(value:String):void
		{
			_playerName = value;
		}

		public function renderEntity(entity:EntityVO):void {
			
			var spriteEntity:SpriteEntity = new SpriteEntity(entity.id);
				
			spriteEntity.x = entity.x; spriteEntity.y = entity.y;
			
			spriteEntity.rotation = entity.rotation; 
			
			_spriteEntityDic[entity.id] = spriteEntity;
			
			spriteEntity.addEventListener(TouchEvent.TOUCH, onTouch);
			spriteEntity.useHandCursor = true;
			
			for each(var square:SquareVO in entity.squaresData){
				var quad:Quad = new Quad(9, 9, 0x00A551);
				quad.x = square.relativePositionX;
				quad.y = square.relativePositionY;
				
				if(Math.abs(quad.x) > Math.abs(_pivotX2))
					_pivotX2 = quad.x;
				
				if(Math.abs(quad.y) > Math.abs(_pivotY2))
					_pivotY2 = quad.y;
				
				spriteEntity.addChild(quad);
			}
			
			if(entity.type == "square"){
				var quad2:Quad = new Quad(9, 9, 0x00A551);
				quad2.x = 0;
				quad2.y = 0;
				spriteEntity.addChild(quad2);
			}
			
			//the pivot is calculated so it takes into account how the squares are orranged
			spriteEntity.pivotX = _pivotX2 / 2; spriteEntity.pivotY = _pivotY2 / 2;
			
			addChild(spriteEntity);
			
			/*var quad:Quad = new Quad(2, 2);
			addChild(quad); quad.x = entity.position.x; quad.y = entity.position.y;*/
		}
		
		public function updateEntity(entity:EntityVO):void {
			_spriteEntityDic[entity.id].x = entity.x;
			_spriteEntityDic[entity.id].y = entity.y;
			_spriteEntityDic[entity.id].rotation = entity.rotation;
		}
		
		public function showTiles():void {
			for(var i:int = 0; i < _tilesArray.length; i++){
				_tilesArray[i].visible = true;
			}
		}
		
		public function pauseOrResumeAnimations():void {
			for each(var id:String in _stateChangeRelatedAnimationsDic){
				_spriteEntityDic[id].pauseOrResume();
			}
		}
		
		public function removeEntity(entityId:String):void {
			removeChild(_spriteEntityDic[entityId], true);
		}
		
		public function addBackground():void {
			var image:Image = new Image(ResourceManager.getInstance().getTexture("background"));
			addChild(image);
		}
		
		public function getSpriteEntitiesDic():Dictionary {
			return _spriteEntityDic;
		}
		
		public function getSpriteEntity(id:String):SpriteEntity {
			return _spriteEntityDic[id];
		}
		
		private function onTouch(e:TouchEvent):void {
			
			/*var mcc:MovieClipContainer = MovieClipContainer(e.currentTarget);
			
			var beganTouch:Touch = e.getTouch(DisplayObject(e.currentTarget), TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(DisplayObject(e.currentTarget), TouchPhase.HOVER);*/
			
		/*	if(MovieClipContainer(e.currentTarget).skinClass.animationsDic["hover"] == true && mcc.currentLabel != "selected"){
				if(hoverTouch) {
					
					if(_hoveredEntity == null || mcc.id != _hoveredEntity.id) {
						playAnimation(mcc.id, "hover");
						mcc.loop(false);
						_hoveredEntity = mcc;
						_manager.dispatchHandler(mcc.id, "hover");
					}
				}
				else {
					_hoveredEntity = null;
					_manager.dispatchHandler(mcc.id, "hoverEnded");
					mcc.stop();
				}
			}
		*/	
			/*if(beganTouch) {
				
				if(mcc.skinClass.animationsDic["selected"] == true)
					playAnimation(mcc.id, "selected");
				
				trace(mcc.localToGlobal(new Point()));
				_manager.dispatchHandler(mcc.id, "click");
				
			}*/
		}
		
		public static function getInstance():Renderer{
			if(!_instance)
				_instance = new Renderer();
			return _instance;
		}
	
	
	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
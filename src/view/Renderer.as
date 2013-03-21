package view
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import managers.Manager;
	
	import model.EntityVO;
	
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
		private var _backgroundImagesArray:Array;
		private var _prevBGImage:int;
		private var _nextBGImage:int;
		private var _bgContainer:Sprite;
		private var _myCore:Sprite;
		private var _enemyCore:Sprite;
		private var _tilesArray:Array;
		
		public function Renderer()
		{
			_spriteEntityDic = new Dictionary();
			_stateChangeRelatedAnimationsDic = new Dictionary();
			_manager = Manager.getInstance();
			_bgContainer = new Sprite();
			_bgContainer.touchable = false;
			_tilesArray = new Array();
			addChild(_bgContainer);
		}
		
		public function set playerName(value:String):void
		{
			_playerName = value;
		}

		public function renderEntity(entity:EntityVO):void {
			
			var spriteEntity:SpriteEntity = new SpriteEntity(entity.id);
				
			spriteEntity.x = entity.position.x; spriteEntity.y = entity.position.y;
			
			spriteEntity.pivotX = spriteEntity.width/2; spriteEntity.pivotY = spriteEntity.height/2;
			
			if(entity.rotation)
				spriteEntity.rotation = entity.rotation; 
			
			_spriteEntityDic[entity.id] = spriteEntity;
			
			spriteEntity.addEventListener(TouchEvent.TOUCH, onTouch);
			spriteEntity.useHandCursor = true;
			
			for(var i:int = 0; i < entity.squaresData.length; i ++){
				var quad:Quad = new Quad(9, 9, 0x00A551);
				quad.x = entity.squaresData[i].relativePosition.x;
				quad.y = entity.squaresData[i].relativePosition.y;
				spriteEntity.addChild(quad);
			}
			
			addChild(spriteEntity);
			
			/*var quad:Quad = new Quad(2, 2);
			addChild(quad); quad.x = entity.position.x; quad.y = entity.position.y;*/
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
		
		public function addCores(entity:EntityVO):void {
			//my core
			_myCore = new Sprite();
			addChild(_myCore);
			var quad:Quad = new Quad(50, 50);
			_myCore.addChild(quad);
			_myCore.x = 350; _myCore.y = 700 + 50;
			
			//enemmy ship
			_enemyCore = new Sprite();
			addChild(_enemyCore);
			var quad2:Quad = new Quad(50, 50);
			_enemyCore.addChild(quad2);
			_enemyCore.x = 350; _enemyCore.y = -100;
			
		}
		
		public function enterCores():void {
			
			/*var tweenMyCore:Tween = new Tween(_myCore, 3, Transitions.EASE_OUT);
			tweenMyCore.animate("y", _myCore.y - 100);
			Starling.juggler.add(tweenMyCore);
			
			var tweenEnemyCore:Tween = new Tween(_enemyCore, 3, Transitions.EASE_OUT);
			tweenEnemyCore.animate("y", _enemyCore.y + 100);
			Starling.juggler.add(tweenEnemyCore);
			
			tweenEnemyCore.onComplete = onCoresAnimationComplete;*/
			
		}
		
		private function onCoresAnimationComplete():void {
			_manager.onEnterCoresComplete();
		}
		
		public function addBackground():void {
			var image:Image = new Image(ResourceManager.getInstance().getTexture("background"));
			addChild(image);
		}
		
		public function getSpriteEntitiesDic():Dictionary {
			return _spriteEntityDic;
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
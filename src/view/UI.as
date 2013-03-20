package view
{
	import actions.Action;
		
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import managers.Manager;
	
	import model.ActionButtonVO;
	import model.EntityVO;
	import model.SquareVO;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	import starling.utils.MatrixUtil;
	
	import utils.ExtendedButton;
	import utils.GameStatus;
	import utils.ResourceManager;
	
	public class UI extends Sprite
	{
		private static var _instance:UI;
		private static const DEFAULT:int = 0;
		private static const WAITING_FOR_TARGET:int = 1;
		private static const BOT:int = 1;
		private static const TOP:int = 0;
		
		private var _clickedEntity:EntityVO;
		private var _stateTxt:TextField;
		private var _playerNameTxt:TextField;
		private var _playerName:String;
		private var _countDownTxt:TextField;
		private var _statusNetTxt:TextField;
		private var _timer:Timer;
		private var _state:int = GameStatus.STOPPED;
		private var _messageCount:int = 1;
		private var _showingCountDown:Boolean;
		private var _status:int = DEFAULT;
		private var _action:Action;
		private var _rallypointContainer:Sprite;
		private var _statusArray:Array;
		private var _showingEntityUI:Boolean = false;
		private var _actionBar:ActionBar;
		private var _mouseCursorImage:Sprite;
		private var _actionIssued:Action;
		private var _pressingShift:Boolean;
		private var _touchedPoint:Point;
		private var _entityBuilder:EntityBuilder;
		private var _entityIssued:EntityVO;
		
		public var online:Boolean;
		
		public function UI(showDebugData:Boolean)
		{
			_statusArray = new Array();
			initActionbar();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (showDebugData)
				showDebugInfo();
		}
		
		//when the game state advance to the planning state, we show the planning UI
		public function showPlanningUI(value:Boolean):void {
		}
		
		public function showVisualMessage(text:String, color:String):void {
			var visualMessage:VisualMessage = new VisualMessage(text, color);
			visualMessage.addEventListener("VisualMessageComplete", onVisualMessageComplete);
			addChild(visualMessage);
		}
		
		private function onVisualMessageComplete(e:Event):void {
			dispatchEvent(new Event("VisualMessageComplete"));
		}
		
		private function onAddedToStage(e:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyPressed);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function initActionbar():void {
			_actionBar = new ActionBar();
			//this way the starting position of the action bar is "hidden"
			_actionBar.x = 800;
			addChild(_actionBar);
			_actionBar.addEventListener("ReadyEvent", sendReadyEvent);
				
		}
		
		public function sendReadyEvent(e:Event):void {
			Manager.getInstance().sendPlayerReadyEvent();
		}
		
		public function enableButtons(bool:Boolean):void {
			_actionBar.enableButtons(bool);	
		}
		
		
		private function onMove(e:TouchEvent):void {
			var touch:Touch = e.touches[0];
			
			if(touch.phase == "hover"){
				_mouseCursorImage.x = touch.globalX;		
				_mouseCursorImage.y = touch.globalY;
			}
		}
		
		
		public function set playerName(value:String):void
		{
			_playerName = value;
		}

		private function onKeyPressed(e:KeyboardEvent):void {
			if(e.shiftKey && !_pressingShift){
				_pressingShift = true;
			}
			
			if(!e.shiftKey) {
				_pressingShift = false;
				Mouse.show();
				removeChild(_mouseCursorImage);
				_mouseCursorImage.dispose();
				//removeChild(_slotPlacementGuide);
				_actionIssued = null;
			}
			
			if(e.keyCode == 27){
				Mouse.show();
				removeChild(_mouseCursorImage);
				_mouseCursorImage.dispose();
				//removeChild(_slotPlacementGuide);
				_actionIssued = null;
			}
		}
		
		private function onTouch(e:TouchEvent):void {
			
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN){
				if(!_entityBuilder){
					_touchedPoint = new Point(touch.globalX, touch.globalY);
					_entityBuilder = new EntityBuilder();
					_entityBuilder.x = _touchedPoint.x;
					_entityBuilder.y = _touchedPoint.y;
					_entityBuilder.playerName = _playerName;
					addChild(_entityBuilder);
					_entityBuilder.addEventListener("cancel", onEntityBuildCancel);
					_entityBuilder.addEventListener("build", onEntityBuildAccept);
				}
				if(_entityIssued){
					stage.removeEventListener(TouchEvent.TOUCH, onMove);
					Mouse.show();
					_entityIssued.position = new Point(touch.globalX, touch.globalY);
					var action:Action = new Action("addEntity", _entityIssued);
					dispatchEventWith("issueAction", false, action);
					removeChild(_mouseCursorImage, true);
					_entityIssued = null;
					
				}
				else{
					_entityBuilder.visible = true;
				}
			}
		}
		
		private function onEntityBuildCancel(e:Event):void {
			_entityBuilder.visible = false;
		}
		
		private function onEntityBuildAccept(e:Event, entity:EntityVO):void {
			
			_entityBuilder.visible = false;
			_entityIssued = entity;
			Mouse.hide();
			createGhostEntityImage(entity.squaresData);
			stage.addEventListener(TouchEvent.TOUCH, onMove);
			
		}
		
		private function createGhostEntityImage(squaresData:Vector.<SquareVO>):void {
			
			_mouseCursorImage = new Sprite();
			
			for(var i:int = 0; i < squaresData.length; i ++){
				var quad:Quad = new Quad(9, 9, 0x00A551);
				quad.alpha = 0.5;
				quad.x = squaresData[i].relativePosition.x;
				quad.y = squaresData[i].relativePosition.y;
				_mouseCursorImage.addChild(quad);
			}
			
			addChild(_mouseCursorImage);
			
		}
		
		public function entityClickedHandler(entity:EntityVO, operation:String):void {
		
			if(operation == "click") {
				
				_clickedEntity = entity;
				
				if(_actionIssued && entity.owner == _playerName) {
				
					_actionIssued.entity.position = entity.position.clone();
					
				}		
				else {
					showEntityUI(_clickedEntity);
				}
			}

			/*if(operation == "hover"){
				_slotPlacementGuide.turnOnOrOffRow(TileVO(entity).row, true);
			}
			
			if(operation == "hoverEnded"){
				_slotPlacementGuide.turnOnOrOffRow(TileVO(entity).row, false);
			}*/
		}
		
		
		//animate action bar entering the stage
		public function showActionBar():void {
			
			var tween:Tween = new Tween(_actionBar, 1.5, Transitions.EASE_OUT);
			tween.animate("x", _actionBar.x - 100);
			Starling.juggler.add(tween);
			tween.onComplete = onShowActionBarTweenComplete;
			
		}
		
		private function onShowActionBarTweenComplete():void {
			dispatchEvent(new Event("actionBarTweenCompleted"));
		}
		
		private function showEntityUI(entity:EntityVO):void {
		/*	if(entity.actionButtons == null) return;
			_showingEntityUI = true;*/
			/*if(_selectorPanel)
				removeEntityUI();
			
			_selectorPanel = new SelectorPanel(entity.actionButtons, entity.position);
			_selectorPanel.addEventListener("selectorPanelEvent", onSelectorTouched);
			_selectorPanel.x = entity.position.x; _selectorPanel.y = entity.position.y;
			addChild(_selectorPanel);*/
		}
		
		//for the moment, using quads to draw, later an animated movieclip would be better
		public function showRallyPoint(entityPosition:Point, rallyPoint:Point, row:String, depth:String):void {
			_showingEntityUI = true;
			_rallypointContainer = new Sprite();

			//first line
			var diff:Point = entityPosition.subtract(rallyPoint); 
			var dist:Number = diff.length;
			
			var quad:Quad = new Quad(4, dist, 0xff5500);
			quad.x = entityPosition.x; quad.y = entityPosition.y;
			
			quad.rotation = Math.atan2(diff.y, diff.x) + 90 * (Math.PI / 180);
			_rallypointContainer.addChild(quad);
			
			//second line
				
			/*var point:Point = new Point(_slotPlacementGuide.getFirstOrLastTile(row, depth).x, _slotPlacementGuide.getFirstOrLastTile(row, depth).y);
			var diff2:Point = rallyPoint.subtract(point); 
			var dist2:Number = diff2.length;*/
			
			/*var quad2:Quad = new Quad(4, dist2, 0xFF0000);
			quad2.x = rallyPoint.x; quad2.y = rallyPoint.y;*/
			
			/*quad2.rotation = depth == "first" ? (-135) * (Math.PI / 180) : (45) * (Math.PI / 180);
			_rallypointContainer.addChild(quad2);
			
			//the arrow
			var texture:Texture = ResourceManager.getInstance().getTexture("arrow");
			var arrow:Image = new Image(texture);
			arrow.pivotX = arrow.width/2; arrow.pivotY = arrow.width/2;
			arrow.rotation = depth == "first" ? 45 * Math.PI / 180 : 225 * Math.PI / 180;
			arrow.useHandCursor = false;
			_rallypointContainer.addChild(arrow);
			
			addChild(_rallypointContainer);*/
		}

		
		public function updateUITurnCountdown(count:int):void {
			_actionBar.updateUITurnCountdown(count);
		}
			
		/*private function onSelectorTouched(e:SelectorPanelEvent):void {
				
				var action:Action;
				
				switch(e.actionType) {
					case "sell":
						action = new Action(e.actionType, _clickedEntity);
						break;
					//if the action type is setRallyPoint, we stop the flow and wait for a target
					case "setRallypoint":
						_status = WAITING_FOR_TARGET;
						_action = new Action(e.actionType, _clickedEntity);
						removeEntityUI();
						return;
						break;
					case "upgrade":
						action = new Action(e.actionType, _clickedEntity);
						break;
				}
				
			removeEntityUI();
		}*/
		
		public function removeEntityUI():void {
			if(!_showingEntityUI) return;
			
			/*removeChild(_selectorPanel);
			_selectorPanel.dispose();*/

			if(_rallypointContainer){
				removeChild(_rallypointContainer);
				_rallypointContainer.dispose();
			}
			_showingEntityUI = false;
		}
		
		private function showDebugInfo():void {
			_stateTxt = new TextField(100, 50, "STOPPED");
			_stateTxt.touchable = false;
			_stateTxt.x = -15;
			_stateTxt.y = -10;
			addChild(_stateTxt);
			
			_playerNameTxt = new TextField(100, 50, _playerName);
			_playerNameTxt.touchable = false;
			_playerNameTxt.x = -5;
			_playerNameTxt.y = 5;
			
			addChild(_playerNameTxt);
		}
		
		public function storeStatusChange(status:String):void {
			showNewNetStatusLine(status);
			_messageCount ++;
		}
		
		private function showNewNetStatusLine(status:String):void {
			var statusNetTxt:TextField = new TextField(200, 20, status, "Verdana", 10);
			statusNetTxt.touchable = false;
			statusNetTxt.x = 0;
			statusNetTxt.y = 150;
			statusNetTxt.y = 10 * _messageCount + 30;
			
			addChild(statusNetTxt);
		}
		
		public function set state(state:int):void {
			_state = state;
			_stateTxt.text = GameStatus.textStatusArray[_state];
			
			if(_state == GameStatus.COUNTDOWN_PLAYING || _state == GameStatus.COUNTDOWN_STOPPED){
				showCountDown();
			}
			
			if(_state == GameStatus.STOPPED)
				//_actionBar.resetReadyButtons();
			
			if(_state == GameStatus.COUNTDOWN_STOPPED && _showingEntityUI)
				removeEntityUI();
		}
		
		
		public function resetUI():void {
			_showingCountDown = false;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			removeChild(_countDownTxt);
		}
		
		public function showCountDown():void {
			_showingCountDown = true;
			_timer = new Timer(1000, 2);
			_countDownTxt = new TextField(200, 100, "2", "Verdana", 60);
			_countDownTxt.x = 300;
			_countDownTxt.y = 200;
			addChild(_countDownTxt);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
			_actionBar.hideTurnCountdown();
		}
		
		private function onTimer(e:TimerEvent):void {
			_countDownTxt.text = String(int(_countDownTxt.text) - 1);
			if ( int(_countDownTxt.text) == 0) {
				_showingCountDown = false;
				removeChild(_countDownTxt);
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				Manager.getInstance().advanceGameState();
			}
				
		}
		
		public static function getInstance(showDebugData:Boolean = true):UI {
			if ( _instance == null )
				_instance = new UI(showDebugData);
			return _instance;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
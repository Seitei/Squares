package managers
{
	import actions.Action;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import model.CoreVO;
	import model.EntityFactoryVO;
	import model.EntityVO;
	import model.WorldVO;
	
	import net.NetConnect;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	import utils.GameStatus;
	import utils.MovieClipContainer;
	
	import view.SpriteEntity;
	import view.UI;
	import view.VisualMessage;
	
	
	public class Manager extends EventDispatcher
	{
		private var _player:Player;
		private var _nc:NetConnect;
		private var _gameManager:GameManager;
		private static var _instance:Manager;
		private var _state:int = GameStatus.INIT;
		private var _main:Main;
		private var _playerName:String;
		private var _imReady:Boolean;
		private var _hesReady:Boolean;
		private var _ui:UI;
		private var _connectionOrder:String;
		private var _turn:String;
		
		public var online:Boolean;
		
		public function Manager()
		{
			
		}
		
		public function init():void {
			
			//TODO receive from server
			_playerName = "Player-" + String(int(1000 * Math.random())) + "_";
			_player = new Player(_playerName, online); 
			_gameManager = GameManager.getInstance();
			_gameManager.playerName = _player.name;
			Main.getInstance().getRenderer().playerName = _playerName;
			_main = Main.getInstance();
			
			_player.addEventListener("notifyPlayerReadyEvent", receiveReadyMessage);
			_player.addEventListener("notifyActionEvent", receiveActionMessage);
			_player.addEventListener("notifyNeighbourConnectedEvent", onNeighborConnected);
			_player.addEventListener("notifyStatusEvent", showStatus);
			
			initUI();
		}
		
		private function initUI():void {
			_ui = UI.getInstance();
			_ui..playerName = _playerName;
			_ui.online = online;
			_ui.addEventListener("VisualMessageComplete", onVisualMessageComplete);
			_ui.addEventListener("actionBarTweenCompleted", onActionBarTweenCompleted);
			_ui.addEventListener("issueAction", handler);
		}
		
		private function onActionBarTweenCompleted(e:Event):void {
			
			_gameManager.enterCores();
			_main.activateEnterFrame(true);
			
		}
		
		
		
		public function get imReady():Boolean
		{
			return _imReady;
		}
		
		public function set imReady(value:Boolean):void
		{
			_imReady = value;
		}
		
		public function getPlayerName():String {
			return _player.name;
		}
		
		public function getUI():UI {
			return _ui;	
		}
		
		private function onNeighborConnected(e:Event, connectionOrder:String):void {
			_connectionOrder = connectionOrder;
			_ui.showVisualMessage("CHALLENGER APPEARS!", "neutral");
		}
		
		private function onVisualMessageComplete(e:Event):void {
			
			switch(_state){
				case GameStatus.INIT:
					trace("INIT");
					buildCore();
					Main.getInstance().removeWelcomeScreen();
					break;
				}
		}
		
		
		public function buildCore():void {
			
			if(_connectionOrder == "second"){
				_turn = "enemyTurn";
			}
			else{
				_turn = "myTurn";
			}
			
			var myCore:EntityVO = EntityFactoryVO.getInstance().makeEntity(_playerName, "core", 1, new Point(350, 725));
			var myCoreAction:Action = new Action("addEntity", myCore);
			
			var myData:Array = new Array();
			myData[0] = "vertexCenteredMode";
			myData[1] = [[0, 0, 0, 0, 0, 0, 0], 
				 		 [0, 0, 0, 0, 0, 0, 0],
						 [0, 0, 1, 1, 0, 0, 0],
						 [0, 0, 1, 1, 0, 0, 0],
						 [0, 0, 0, 0, 0, 0, 0],
						 [0, 0, 0, 0, 0, 0, 0],
						 [0, 0, 0, 0, 0, 0, 0]];
					
			myCore.data = myData;
			
			this.addEventListener("issueAction", handler);
			dispatchEventWith("issueAction", false, myCoreAction);
			
			//if not online, we force a send with different id and owner to create the enemy core as well
			if(!online){
				var enemyCore:EntityVO = EntityFactoryVO.getInstance().makeEntity(_playerName, "core", 1, new Point(350, -25));
				enemyCore.owner = "TEST";
				enemyCore.id = "TEST" + enemyCore.id.substring(enemyCore.id.indexOf("_"));
				
				var enemyData:Array = new Array();
				enemyData[0] = "vertexCenteredMode";
				enemyData[1] = [[0, 0, 0, 0, 0, 0, 0], 
							 [0, 0, 0, 0, 0, 0, 0],
							 [0, 0, 1, 1, 0, 0, 0],
							 [0, 0, 1, 1, 0, 0, 0],
							 [0, 0, 0, 0, 0, 0, 0],
							 [0, 0, 0, 0, 0, 0, 0],
							 [0, 0, 0, 0, 0, 0, 0]];
									 
				enemyCore.data = enemyData;
				
				var enemyCoreAction:Action = new Action("addEntity", enemyCore);
				dispatchEventWith("issueAction", false, enemyCoreAction);
			}
			
			//send now with a delay, remove this patch when final implementation is in progress
			var timer:Timer = new Timer(500, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			_main.startGame();
			
			_ui.showActionBar();
			
			
		}
		
		public function onEnterCoresComplete():void {
			
			advanceGameState();
			
			if(_turn == "enemyTurn")
				_ui.showVisualMessage("ENEMY TURN", "enemy");
			else
				_ui.showVisualMessage("YOUR TURN", "me");
		}
		
		private function onTimer(e:TimerEvent):void {
			sendActionBuffer();
		}
		
		public function sendPlayerReadyEvent():void {
			
			if(!online){
				if(!_imReady){
					_imReady = true;
					_playerName = "TEST";
					Main.getInstance().getRenderer().playerName = "TEST";
					UI.getInstance().playerName = "TEST";					
				}
				else{
					advanceGameState();	
				}
			}
			else{
				_imReady = true;
				
				if(_hesReady)
					advanceGameState();
				else
					_turn = "enemyTurn";
				
				_player.sendReadyMessage(_playerName);
				
			}
		}
		
		private function showStatus(e:Event, status:String):void {
			_main.storeStatusData(status);
		}
		
		public function handler(e:Event, action:Action):void {
			
			/*if(!online){
				_player.addToActionBuffer(action);
			}*/
			
			_gameManager.updateWorld(action);
			
		}
		
		public function updateUITurnCountdown(count:int):void {
			UI.getInstance().updateUITurnCountdown(count);
		}
		
		public function advanceGameState():void {
			
			_hesReady = false;
			_imReady = false;
			_state = GameStatus.nextState(_state);
			_gameManager.state = _state;
			_main.state = _state;
			UI.getInstance().state = _state;
			
			if(_state == GameStatus.COUNTDOWN_STOPPED) {
				sendActionBuffer();
			}
			
			if(_state == GameStatus.STOPPED) {
				Main.getInstance().getRenderer().pauseOrResumeAnimations();
			}
			
			if(_state == GameStatus.PLAYING) {
				Main.getInstance().getRenderer().pauseOrResumeAnimations();
			}
		}
		
		public function sendActionBuffer():void {
			_player.sendActionBuffer(online);
		}
		
		private function receiveActionMessage(event:Event, actionBuffer:Vector.<Action> ):void {
			_player.receiveMessage(actionBuffer);
			_gameManager.updatePlayersWorld(actionBuffer);
		}
		
		private function receiveReadyMessage(event:Event):void {
			_hesReady = true;
			if(_imReady) {
				advanceGameState();
			}
			else {
				_turn = "myTurn";
				_ui.showVisualMessage("YOUR TURN", "me");
			}
		}
		
		
		public static function getInstance():Manager {
			if ( _instance == null )
				_instance = new Manager;
			return _instance;
		}
		
		public function loop():void {
			_gameManager.loop();
		}
		
		
		
		
		
		
		
		
	}	
}
package view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;
	
	import model.ActionButtonVO;
	import model.EntityVO;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import utils.ExtendedButton;
	import utils.ResourceManager;
	
	public class ActionBar extends Sprite
	{
		private var _time:int;
		private var _timeTxt:TextField;
		private var _turnCountdownTxt:TextField;
		private var _hesReady:Boolean;
		
		public function set time(value:int):void
		{
			_time = value;
		}

		public function ActionBar() {
			
			//background
			var texture:Texture;
			texture = ResourceManager.getInstance().getTexture("action_bar_bg");
			var image:Image = new Image(texture);
			addChild(image);
			
			initReadyButton();
			//initTurnCountdown();
		}
		
		
		private function initReadyButton():void {
			var readyButton:ExtendedButton = new ExtendedButton(
				ResourceManager.getInstance().getTexture("ready_up_btn"), 
				"",
				ResourceManager.getInstance().getTexture("ready_down_btn"), 
				ResourceManager.getInstance().getTexture("ready_hover_btn")
			);
			
			readyButton.x = 0;
			readyButton.y = 660;
			addChild(readyButton);
			readyButton.addEventListener("buttonTriggeredEvent", onReadyButtonTouched);
			
		}
		
		private function onReadyButtonTouched(e:Event):void {
			dispatchEventWith("readyEvent", true); 
		}
		
		
		public function updateUITurnCountdown(count:int):void {
			_turnCountdownTxt.text = String(count);	
		}
		
		public function hideTurnCountdown():void {
			_turnCountdownTxt.text = "";
		}
		
		
		private function initTurnCountdown():void {
			_turnCountdownTxt = new TextField(150, 50, "3", "ObelixPro", 16, 0, false);
			_turnCountdownTxt.x = 25;
			_turnCountdownTxt.y = 620;
			_turnCountdownTxt.color = 0x00ADEE;
			_turnCountdownTxt.text = "";
			_turnCountdownTxt.width = 100;
			addChild(_turnCountdownTxt);
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
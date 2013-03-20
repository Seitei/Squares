package view
{
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	3
	import utils.ResourceManager;
	import starling.utils.Color;

	public class VisualMessage extends Sprite
	{
		private var _textToShow:String;
		private var _textToShowTxt:TextField;
		private static var ANIMATION_TIME:Number = 0.5;
		private var _topBar:Image;
		private var _botBar:Image;
		private var _bodyBg:Image;
		private var _clippedText:ClippedSprite;
		
		public function VisualMessage(text:String, color:String)
		{
			this.x = 400;
			this.y = 350;
			
			_textToShow = text;
			
			_textToShowTxt = new TextField(700, 120, _textToShow, "Verdana", 60, 0);
			
			//animate();
			
		}

		private function animate():void {
			
			var timer:Timer = new Timer(20, 25);
			timer.addEventListener(TimerEvent.TIMER, onTimerInitClipped);
			timer.start();
			
		}
		
		private function onTimerInitClipped(e:TimerEvent):void {
			
			_clippedText.clipRect.y --;
			_clippedText.clipRect.height += 2;
		}
		
		private function onTimerEndClipped(e:TimerEvent):void {
			
			_clippedText.clipRect.y ++;
			_clippedText.clipRect.height -= 2;
		}
		
		private function onTweenComplete():void {
			
			var topBarTeen:Tween = new Tween(_topBar, ANIMATION_TIME, Transitions.EASE_IN_OUT);
			topBarTeen.animate("x", 750);
			topBarTeen.delay = 1;
			topBarTeen.onStart = onEndingTweenStart;
			Starling.juggler.add(topBarTeen);
			
			var botBarTween:Tween = new Tween(_botBar, ANIMATION_TIME, Transitions.EASE_IN_OUT);
			botBarTween.delay = 1.5;
			botBarTween.animate("x", -750);
			Starling.juggler.add(botBarTween);
		
			var bodyBgTween:Tween = new Tween(_bodyBg, ANIMATION_TIME, Transitions.EASE_IN_OUT);
			bodyBgTween.delay = 1.5;
			bodyBgTween.animate("scaleY", 0);
			Starling.juggler.add(bodyBgTween);
			
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			dispatchEvent(new Event("VisualMessageComplete"));
			this.dispose();
		}
		
		private function onEndingTweenStart():void {
			
			var timer:Timer = new Timer(20, 25);
			timer.addEventListener(TimerEvent.TIMER, onTimerEndClipped);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
		}
		
		
		
		
		
		public function set textToShow(value:String):void
		{
			_textToShow = value;
			_textToShowTxt.text = value;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	}
}
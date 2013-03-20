package view
{
	import actions.Action;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.utils.getTimer;
	
	import model.EntityFactoryVO;
	import model.EntityVO;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PixelMaskDisplayObject;
	import starling.textures.Texture;
	
	import utils.ExtendedButton;
	import utils.ResourceManager;
	
	public class EntityBuilder extends Sprite
	{
		private var _squareTypesButtonsArray:Array;
		private var _squareCenteredMatrixDisposition:Array; 
		private var _vertexCenteredMatrixDisposition:Array;
		private var _squaresArray:Array;
		private var _squaresContainer:Sprite;
		private var _currentCenteredMode:String;
		private var _entity:EntityVO;
		private var _entityData:Array;
		private var _bgMaskContainer:PixelMaskDisplayObject;
		private var _bgImage:Image;
		private var _playerName:String;
		
		public function get playerName():String
		{
			return _playerName;
		}

		public function set playerName(value:String):void
		{
			_playerName = value;
		}

		private function init():void {
			
			initEntityData();
			_squaresContainer = new Sprite(); 
			addChild(_squaresContainer);
			_currentCenteredMode = "square";
			_entity = EntityFactoryVO.getInstance().makeEntity(_playerName, "spawner", 1);
			initCenterDispositionLayout();
		}
		
		private function initEntityData():void {
			_entityData = new Array();
			_entityData[0] = "squareCenteredMode";
			_entityData[1] = [[0, 0, 0, 0, 0, 0, 0], 
						      [0, 0, 0, 0, 0, 0, 0],
							  [0, 0, 0, 0, 0, 0, 0],
							  [0, 0, 0, 0, 0, 0, 0],
							  [0, 0, 0, 0, 0, 0, 0],
							  [0, 0, 0, 0, 0, 0, 0],
							  [0, 0, 0, 0, 0, 0, 0]];
		}
		
		
		private function initCenterDispositionLayout():void {
			
			_squareCenteredMatrixDisposition = new Array;
			
			_squareCenteredMatrixDisposition[0] = [0, 0, 0, 1, 0, 0, 0];
			_squareCenteredMatrixDisposition[1] = [0, 1, 1, 1, 1, 1, 0];
			_squareCenteredMatrixDisposition[2] = [0, 1, 1, 1, 1, 1, 0];
			_squareCenteredMatrixDisposition[3] = [1, 1, 1, 1, 1, 1, 1];
			_squareCenteredMatrixDisposition[4] = [0, 1, 1, 1, 1, 1, 0];
			_squareCenteredMatrixDisposition[5] = [0, 1, 1, 1, 1, 1, 0];
			_squareCenteredMatrixDisposition[6] = [0, 0, 0, 1, 0, 0, 0];
			
			_vertexCenteredMatrixDisposition = new Array();
			
			_vertexCenteredMatrixDisposition[0] = [0, 1, 1, 1, 1, 0, 0];
			_vertexCenteredMatrixDisposition[1] = [1, 1, 1, 1, 1, 1, 0];
			_vertexCenteredMatrixDisposition[2] = [1, 1, 1, 1, 1, 1, 0];
			_vertexCenteredMatrixDisposition[3] = [1, 1, 1, 1, 1, 1, 0];
			_vertexCenteredMatrixDisposition[4] = [1, 1, 1, 1, 1, 1, 0];
			_vertexCenteredMatrixDisposition[5] = [0, 1, 1, 1, 1, 0, 0];
			_vertexCenteredMatrixDisposition[6] = [0, 0, 0, 0, 0, 0, 0];
			
			_squaresArray = new Array();
			
			for(var i:int = 0; i < 7; i ++){
				
				_squaresArray[i] = new Array();
				
				for(var j:int = 0; j < 7; j ++){
					
					var squareButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("square_up"), i + "_" + j, 1, null, null, "",
						ResourceManager.getInstance().getTexture("square_down"),	
						ResourceManager.getInstance().getTexture("square_hover"));
					
					squareButton.x = i * 25;
					squareButton.y = j * 25;
					_squaresArray[i][j] = squareButton;
					_squaresContainer.addChild(squareButton);
					
					squareButton.addEventListener("buttonTriggeredEvent", onSquareButtonClicked);
				}
			}
				 
			setCenterDispositionLayout("squareCenteredMode");
		}
		
		private function onSquareButtonClicked(e:Event):void {
				
			var i:int = int(ActionButton(e.currentTarget).actionType.substr(0, 1));
			var j:int = int(ActionButton(e.currentTarget).actionType.substr(2, 1));

			if(ActionButton(e.currentTarget).IsForced){
				ActionButton(e.currentTarget).forceDownState(false);
				_entityData[1][i][j] = 0;					
			}
			else {
				_entityData[1][i][j] = ActionButton(e.currentTarget).entityType;
				ActionButton(e.currentTarget).forceDownState(true);
			}
		}
		
		private function setCenterDispositionLayout(disposition:String):void {
			
			_currentCenteredMode = disposition;
			_entityData[0] = _currentCenteredMode; 
			
			if(disposition == "squareCenteredMode"){
				for(var i:int = 0; i < 7; i ++){
					for(var j:int = 0; j < 7; j ++){
						if(_squareCenteredMatrixDisposition[i][j] == 1){
							_squaresArray[i][j].enabled = true;
						}
						else{
							_squaresArray[i][j].enabled = false;
						}
					}
				}
			}
			
			if(disposition == "vertexCenteredMode"){
				for(var i2:int = 0; i2 < 7; i2 ++){
					for(var j2:int = 0; j2 < 7; j2 ++){
						if(_vertexCenteredMatrixDisposition[i2][j2] == 1){
							_squaresArray[i2][j2].enabled = true;
						}
						else{
							_squaresArray[i2][j2].enabled = false;
						}
					}
				}
			}
			
			
		}
		
		private function changeCenterDispositionLayout(e:Event):void {
		
			if(_currentCenteredMode == ActionButton(e.currentTarget).actionType)
				return;
			
			_currentCenteredMode = ActionButton(e.currentTarget).actionType;
			_entityData[0] = _currentCenteredMode; 
			
			if(ActionButton(e.currentTarget).actionType == "squareCenteredMode"){
				for(var i:int = 0; i < 7; i ++){
					for(var j:int = 0; j < 7; j ++){
						if(_squareCenteredMatrixDisposition[i][j] == 1){
							_squaresArray[i][j].enabled = true;
						}
						else{
							_squaresArray[i][j].enabled = false;
						}
					}
				}
			}
			
			if(ActionButton(e.currentTarget).actionType == "vertexCenteredMode"){
				for(var i2:int = 0; i2 < 7; i2 ++){
					for(var j2:int = 0; j2 < 7; j2 ++){
						if(_vertexCenteredMatrixDisposition[i2][j2] == 1){
							_squaresArray[i2][j2].enabled = true;
						}
						else{
							_squaresArray[i2][j2].enabled = false;
							
						}
					}
				}
			}
			
			if(_currentCenteredMode == "squareCenteredMode"){
				var squaresTween:Tween = new Tween(_squaresContainer, 0.5, Transitions.EASE_OUT);
				squaresTween.animate("x", _squaresContainer.x - 12.5);
				squaresTween.animate("y", _squaresContainer.y - 12.5);
				Starling.juggler.add(squaresTween);
				
				var bgTween:Tween = new Tween(_bgImage, 0.5, Transitions.EASE_OUT);
				bgTween.animate("x", _bgImage.x - 12.5);
				bgTween.animate("y", _bgImage.y - 12.5);
				Starling.juggler.add(bgTween);
				
			}
			else{
				var squaresTween2:Tween = new Tween(_squaresContainer, 0.5, Transitions.EASE_OUT);
				squaresTween2.animate("x", _squaresContainer.x + 12.5);
				squaresTween2.animate("y", _squaresContainer.y + 12.5);
				Starling.juggler.add(squaresTween2);
				
				var bgTween2:Tween = new Tween(_bgImage, 0.5, Transitions.EASE_OUT);
				bgTween2.animate("x", _bgImage.x + 12.5);
				bgTween2.animate("y", _bgImage.y + 12.5);
				Starling.juggler.add(bgTween2);
			}
			
			
			
		}
		
		
		public function EntityBuilder()
		{
			init();
			
			//////  background //////
			
			_bgImage = new Image(ResourceManager.getInstance().getTexture("entity_builder_background"));
			_bgImage.x = -25;
			_bgImage.y = -25;
			
			// draw circle mask source
			var shape:Shape = new Shape();
			
			shape.graphics.beginFill(0x00ff00, 1);
			shape.graphics.drawCircle(90, 90, 90);
			shape.graphics.endFill();
			
			
			var bmpData:BitmapData = new BitmapData(180, 180, true, 0x0);
			bmpData.draw(shape);
			
			var circleImage:Image = new Image(Texture.fromBitmapData(bmpData, false, false, 1));	
			
			_bgMaskContainer = new PixelMaskDisplayObject();
			_bgMaskContainer.addChild(_bgImage);
			_bgMaskContainer.mask = circleImage;
			_bgMaskContainer.touchable = false;
			
			addChild(_bgMaskContainer);
			
			// draw circle background
			var shape2:Shape = new Shape();
			
			shape2.graphics.lineStyle(1, 0x00A551, 0.35);
			shape2.graphics.drawCircle(90, 90, 90);
			
			shape2.graphics.beginFill(0x00A551, 0.15);
			shape2.graphics.drawCircle(90, 90, 90);
			shape2.graphics.endFill();
			
			var bmpData2:BitmapData = new BitmapData(180, 180, true, 0x0);
			bmpData2.draw(shape2);
			
			var circleImage2:Image = new Image(Texture.fromBitmapData(bmpData2, false, false, 1));
			circleImage2.touchable = false;
			addChild(circleImage2);
			
		
			////// entity formation buttons //////
			
			var formation1Button:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("formation_1_up"), "formation_1", 0, null, null, "",
				ResourceManager.getInstance().getTexture("formation_1_down"),	
				ResourceManager.getInstance().getTexture("formation_1_hover"));
			
			formation1Button.x = 0;
			formation1Button.y = -30;
			addChild(formation1Button);
			
			var formation2Button:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("formation_2_up"),	"formation_2", 0, null, null, "",
				ResourceManager.getInstance().getTexture("formation_2_down"),
				ResourceManager.getInstance().getTexture("formation_2_hover"));
			
			formation2Button.x = 40;
			formation2Button.y = -22;
			addChild(formation2Button);
		
		
			var formation3Button:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("formation_3_up"),	"formation_3", 0, null, null, "",
				ResourceManager.getInstance().getTexture("formation_3_down"),
				ResourceManager.getInstance().getTexture("formation_3_hover"));
			
			formation3Button.x = 80;
			formation3Button.y = -30;
			addChild(formation3Button);
			
			var formation4Button:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("formation_4_up"),	"formation_4", 0, null, null, "",
				ResourceManager.getInstance().getTexture("formation_4_down"),
				ResourceManager.getInstance().getTexture("formation_4_hover"));
			
			formation4Button.x = 120;
			formation4Button.y = -30;
			addChild(formation4Button);
			
			var formation5Button:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("formation_5_up"), "formation_5", 0, null, null, "",
				ResourceManager.getInstance().getTexture("formation_5_down"),
				ResourceManager.getInstance().getTexture("formation_5_hover"));
			
			formation5Button.x = 150;
			formation5Button.y = -30;
			addChild(formation5Button);
		
		
		
		
			////// square type buttons //////
			_squareTypesButtonsArray = new Array();
			
			var balancedSquareButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("balanced_square_up"), "changeSquareTypeToBalanced", 0, null, null, "",
				ResourceManager.getInstance().getTexture("balanced_square_down"),
				ResourceManager.getInstance().getTexture("balanced_square_hover"));
			
			
			var lightweightSquareButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("lightweight_square_up"), "changeSquareTypeToLightweight", 0, null, null, "",
				ResourceManager.getInstance().getTexture("lightweight_square_down"),
				ResourceManager.getInstance().getTexture("lightweight_square_hover"));
			
			var armoredSquareButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("armored_square_up"), "changeSquareTypeToArmored", 0, null, null, "",
				ResourceManager.getInstance().getTexture("armored_square_down"),
				ResourceManager.getInstance().getTexture("armored_square_hover"));
			
			var glasscannonSquareButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("glasscannon_square_up"), "changeSquareTypeToGlasscannon", 0, null, null, "",
				ResourceManager.getInstance().getTexture("glasscannon_square_down"),
				ResourceManager.getInstance().getTexture("glasscannon_square_hover"));
			
			balancedSquareButton.addEventListener("buttonTriggeredEvent", onSquareTypeButtonClicked);
			lightweightSquareButton.addEventListener("buttonTriggeredEvent", onSquareTypeButtonClicked);
			armoredSquareButton.addEventListener("buttonTriggeredEvent", onSquareTypeButtonClicked);
			glasscannonSquareButton.addEventListener("buttonTriggeredEvent", onSquareTypeButtonClicked);
			
			_squareTypesButtonsArray.push(balancedSquareButton, lightweightSquareButton, armoredSquareButton, glasscannonSquareButton);
			
			balancedSquareButton.x = 28; balancedSquareButton.y = 200;
			lightweightSquareButton.x = 63; lightweightSquareButton.y = 200;
			armoredSquareButton.x = 98; armoredSquareButton.y = 200;
			glasscannonSquareButton.x = 133; glasscannonSquareButton.y = 200;
			
			addChild(balancedSquareButton);
			addChild(lightweightSquareButton);
			addChild(armoredSquareButton);
			addChild(glasscannonSquareButton);
			
		
			////// ok and cancel buttons //////
			
			var acceptButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("accept_entity_up"), "accept", 0, null, null, "",
				ResourceManager.getInstance().getTexture("accept_entity_down"),
				ResourceManager.getInstance().getTexture("accept_entity_hover"));
			
			var cancelButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("cancel_entity_up"), "cancel", 0, null, null, "",
				ResourceManager.getInstance().getTexture("cancel_entity_down"),
				ResourceManager.getInstance().getTexture("cancel_entity_hover"));
		
			acceptButton.x = 195; acceptButton.y = 65;
			cancelButton.x = 195; cancelButton.y = 95;	
		
			addChild(acceptButton);
			addChild(cancelButton);
			
			acceptButton.addEventListener("buttonTriggeredEvent", onAcceptButtonClicked);
			cancelButton.addEventListener("buttonTriggeredEvent", onCancelButtonClicked);
			
			////// tower/unit button //////
			
			var normalSquareButton:ActionButton = new ActionButton( ResourceManager.getInstance().getTexture("square_type_normal_up"), "normalSquare", 0, null, null, "",
				ResourceManager.getInstance().getTexture("square_type_normal_down"),
				ResourceManager.getInstance().getTexture("square_type_normal_hover"));
			
			var towerSquareButton:ActionButton = new ActionButton( ResourceManager.getInstance().getTexture("square_type_tower_up"), "towerSquare", 0, null, null, "",
				ResourceManager.getInstance().getTexture("square_type_tower_down"),
				ResourceManager.getInstance().getTexture("square_type_tower_hover"));
			
			normalSquareButton.x = -30; normalSquareButton.y = 65;
			towerSquareButton.x = -33; towerSquareButton.y = 95;	
			
			addChild(normalSquareButton);
			addChild(towerSquareButton);
			
			
			////// change center buttons //////
		
			var squareCenteredButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("square_centered_up"), "squareCenteredMode", 0, null, null, "",
				ResourceManager.getInstance().getTexture("square_centered_down"),
				ResourceManager.getInstance().getTexture("square_centered_hover"));
			
			var vertexCenteredButton:ActionButton =	new ActionButton( ResourceManager.getInstance().getTexture("vertex_centered_up"), "vertexCenteredMode", 0, null, null, "",
				ResourceManager.getInstance().getTexture("vertex_centered_down"),
				ResourceManager.getInstance().getTexture("vertex_centered_hover"));
			
			squareCenteredButton.x = 0; squareCenteredButton.y = 160;
			vertexCenteredButton.x = 165; vertexCenteredButton.y = 160;	
			
			squareCenteredButton.addEventListener("buttonTriggeredEvent", changeCenterDispositionLayout);
			vertexCenteredButton.addEventListener("buttonTriggeredEvent", changeCenterDispositionLayout);
		
			addChild(vertexCenteredButton);
			addChild(squareCenteredButton);
			
		
		}
	
		private function onAcceptButtonClicked(e:Event):void {
			
			_entity.data = _entityData;
			dispatchEventWith("build", true, _entity);
		}
		
		private function onCancelButtonClicked(e:Event):void {
			dispatchEventWith("cancel", true);
		}
		
		private function onSquareTypeButtonClicked(e:Event):void {
			
			var ab:ActionButton = ActionButton(e.currentTarget);
			ab.forceDownState(true);
			
			for each(var button:ActionButton in _squareTypesButtonsArray) {
				
					if(button.actionType != ab.actionType)
						button.forceDownState(false);
			}
			 
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	
	
	}
}
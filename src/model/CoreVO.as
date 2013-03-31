package model
{
	import flash.geom.Point;
	
	import managers.GameManager;

	public class CoreVO extends EntityVO
	{
		private var _issuedEntities:Vector.<EntityVO>;
		
		private var _spawnRate:Number = 120; 
		private var _timePassed:int;
		private var _counter:int;
		
		public function CoreVO(posX:int, posY:int)
		{
			super("core");
			x = posX;
			y = posY;
			_issuedEntities = new Vector.<EntityVO>;
		}
		
		public function issueEntity(entity:EntityVO):void {
			_issuedEntities.push(entity);
			behavior.push(spawnSquares, refreshSquares);
			
		}
		
		private function spawnSquares():void {
			
			_timePassed ++;
			
			if(_timePassed == _spawnRate){
				var square:EntityVO = EntityFactoryVO.getInstance().makeEntity(GameManager.getInstance().playerName, "square", 1, squaresData[_counter].relativePositionX + this.x, squaresData[_counter].relativePositionY + this.y);
				GameManager.getInstance().addEntity(square);
				GameManager.getInstance().updateEntity(square, "setRallypoint", 
					new Point(_issuedEntities[0].squaresData[_counter].relativePositionX + _issuedEntities[0].x,
						      _issuedEntities[0].squaresData[_counter].relativePositionY + _issuedEntities[0].y),  
							  true);
				_timePassed = 0;
				_counter ++;
				if(_counter == _issuedEntities[0].squaresData.length){
					behavior.splice(behavior.indexOf(spawnSquares, 0), 1);
					_counter = 0;
				}
			}
		}
		
		
		private function refreshSquares():void {
			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}
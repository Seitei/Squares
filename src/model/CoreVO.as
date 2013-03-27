package model
{
	public class CoreVO extends EntityVO
	{
		private var _issuedEntities:Vector.<EntityVO>;
		
		public function CoreVO(posX:int, posY:int)
		{
			super();
			type = "core";
			x = posX;
			y = posY;
			_issuedEntities = new Vector.<EntityVO>;
			speed = 0.5;
		}
		
		public function issueEntity(entity:EntityVO):void {
			_issuedEntities.push(entity);
			behavior.push(moveSquares, refreshSquares, spawnSquares);
		}
		
		override public function loop():void {
			
			for each(var foo:Function in behavior){
				foo();
			}
			
		}
		
		private function moveSquares():void {
			
			
		}
		
		private function refreshSquares():void {
			
			
		}
		
		private function spawnSquares():void {
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
	}
}
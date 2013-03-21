package model
{
	public class CoreVO extends EntityVO
	{
		private var _issuedEntity:EntityVO;
		
		public function CoreVO(posX:int, posY:int)
		{
			super();
			type = "core";
			position.x = posX;
			position.y = posY;
		}
		
		
		public function get issuedEntity():EntityVO
		{
			return _issuedEntity;
		}

		public function set issuedEntity(value:EntityVO):void
		{
			_issuedEntity = value;
		}

	}
}
package model
{
	public class SpawnerVO extends EntityVO
	{
		public function SpawnerVO(posX:int, posY:int)
		{
			super("spawner");
			x = posX;
			y = posY;
		}
	}
}
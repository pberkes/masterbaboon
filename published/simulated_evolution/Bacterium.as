package  
{
	import flash.display.Shape;
	
	/**
	 * Class defining bacteria
	 * @author Pietro Berkes
	 */
	public class Bacterium extends Shape {
		public static const RADIUS:int = 2;
		
		public function Bacterium(x:int, y:int) {
			this.x = x;
			this.y = y;
			
			graphics.lineStyle(1);
			graphics.beginFill(0xFFFF00);
			graphics.drawCircle(0, 0, RADIUS);
		}
		
	}
	
}
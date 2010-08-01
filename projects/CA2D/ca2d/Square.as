package  
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	
	/**
	 * This class represent one element of the CA, it can be
	 * switched ON/OFF with the mouse; the color starts red and fades to black
	 * the more the element remains active
	 * @author Pietro Berkes
	 */
	public class Square extends Sprite
	{
		// CONSTANTS
		// initial color of the square
		protected const INITIALCOLOR:Number = 0xFF0000;
		
		protected var active:Boolean;
		protected var colorTransform:ColorTransform = new ColorTransform();
		
		public function Square(x:int, y:int, size:int) {
			// design
			graphics.beginFill(INITIALCOLOR);
			graphics.drawRect(0, 0, size, size);
			transform.colorTransform = colorTransform;
			
			// init
			this.x = x;
			this.y = y;
			setActive(false);
			
			// listeners
			addEventListener(MouseEvent.MOUSE_OVER, mouseDownListener);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
		}
		
		public function setActive(active:Boolean):void {
			// update color

			if (this.active && active) colorTransform.redMultiplier *= 0.9;
			if (!this.active && active) colorTransform.redMultiplier = 1;
			transform.colorTransform = colorTransform;
			
			// update state
			this.active = active;
			if (active) {
				alpha = 1.0;
			} else {
				alpha = 0.0;
			}
		}
		
		public function getActive():Boolean {
			return active;
		}
		
		/*
		 * LISTENERS
		 */
		public function mouseDownListener(e: MouseEvent):void {
			if (e.buttonDown)
				setActive(!active);
		}
	}
	
}
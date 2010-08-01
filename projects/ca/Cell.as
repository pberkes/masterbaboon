/**
 *	@author  >> Justin Windle
 *	@link	 >> soulwire.co.uk
 *	@version >> 0.1
 */

package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Cell extends Sprite
	{
		
		/*
		========================================================
		| Private Variables                         | Data Type  
		========================================================
		*/
		
		private var _size:							int;
		private var _state:							int;
		private var _colours:                       Array = [ 0x2B2B2B, 0x666666, 0xFFFFFF, 0x666666 ];
		
		/*
		========================================================
		| Public Variables                          | Data Type  
		========================================================
		*/
		
		public var newState:						int;
		
		public static const EMPTY:					int = 0;
		public static const SPAWN:					int = 1;
		public static const ALIVE:					int = 2;
		public static const DEAD:					int = 3;
		
		/*
		========================================================
		| Constructor
		========================================================
		*/
		
		/**
		 * A grid cell containing methods for switching to 'Empty' or 'Alive' using mouse clicks
		 * @param	size	The dimensions of the cell
		 */
		
		public function Cell( size:int ) 
		{
			_state = newState = EMPTY;
			_size = size;
			draw();
			
			buttonMode = true;
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.CLICK, onClick );
		}
		
		/*
		========================================================
		| Private Methods
		========================================================
		*/
		
		/**
		 *	Draws the cell using a colour depentant on the state of the cell 
		 */
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill( _colours[ _state ] );
			graphics.drawCircle( _size/2, _size/2, _size/2 );
			graphics.endFill();
		}
		
		/*
		========================================================
		| Public Methods
		========================================================
		*/
		
		/*
		========================================================
		| Event Handlers
		========================================================
		*/
		
		private function onMouseOver( e:MouseEvent ):void
		{
			graphics.clear();
			graphics.lineStyle( 2, 0xFFFFFF );
			graphics.beginFill( 0x2b2b2b );
			graphics.drawCircle( _size/2, _size/2, _size/2 );
			graphics.endFill();
		}
		
		private function onMouseOut( e:MouseEvent ):void
		{
			draw();
		}
		
		private function onClick( e:MouseEvent ):void
		{
			state = ( _state == ALIVE ? EMPTY : ALIVE );
		}
		
		/*
		========================================================
		| Getters + Setters
		========================================================
		*/
		
		/**
		 * sets the state of the cell and redraws its graphics accordingly
		 */
		
		public function set state( status:int ):void
		{
			_state = status;
			draw();
		}
		
		public function get state():int { return _state }
		public function get ok():Boolean { return ( _state == ALIVE || _state == SPAWN ) }
		
	}
	
}

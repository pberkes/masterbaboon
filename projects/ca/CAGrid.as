/**
 *	@author  >> Justin Windle
 *	@link	 >> soulwire.co.uk
 *	@version >> 0.1
 */

package  
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class CAGrid extends Sprite
	{
		
		/*
		========================================================
		| Private Variables                         | Data Type  
		========================================================
		*/
		
		private var _max:							int;
		private var _size:							int;
		private var _segments:						int;
		private var _cellSize:						int;
		private var _cellPad:						int;
		private var _cells:							Array;
		private var _generation:					int;
		
		/*
		========================================================
		| Constructor
		========================================================
		*/
		
		/**
		 * A grid of cells used to produce a 2 dimensional cellular automata
		 * @param	gridSize	The dimensions in pixels of the grid
		 * @param	segments	The number of cells in each row or column
		 * @param	cellPad		The padding (or spacing) inside each cell
		 */
		
		public function CAGrid( gridSize:int, segments:int, cellPad:int ) 
		{
			_size = gridSize;
			_cellPad = cellPad;
			_segments = segments;
			_max = segments - 1;
			_generation = 0;
			
			calculateGrid();
			createGrid();
		}
		
		/*
		========================================================
		| Private Methods
		========================================================
		*/
		
		/**
		 * Calculates the size of each cell as determined by the gridSize and segments parameters
		 */
		
		private function calculateGrid():void
		{
			_cellSize = (( _size / _segments ) - _cellPad) << 0;
		}
		
		/**
		 * Creates a grid of cells and builds a 2 dimensional array holding refferences to them
		 */
		
		private function createGrid():void
		{
			_cells = new Array();
			while ( numChildren > 0 ) removeChildAt(0);
			
			for (var x:int = 0; x < _segments; x++) 
			{
				_cells[x] = new Array();
				for (var y:int = 0; y < _segments; y++) 
				{
					var cell:Cell = new Cell( _cellSize );
					cell.x = x * (_cellSize + _cellPad);
					cell.y = y * (_cellSize + _cellPad);
					
					_cells[x][y] = addChild( cell );
				}
			}
		}
		
		/*
		========================================================
		| Public Methods
		========================================================
		*/
		
		/**
		 * Updates each cell by assessing the status of each surrounding cell
		 * @param	e	Optional event parameter if calling the method directly from a timer or enterframe event
		 */
		
		public function update( e:Event = null ):void
		{
			var x:int;
			var y:int;
			
			var cell:Cell;
			var bros:int;
			
			for (x = 0; x < _segments; x++) 
			{
				for (y = 0; y < _segments; y++) 
				{
					cell = _cells[x][y];
					bros = 0;

					// North
					if ( y > 0 )
						if ( _cells[x][y-1].ok ) bros++;
					
					// North East
					if ( x < _max && y > 0 )
						if ( _cells[x+1][y-1].ok ) bros++;
					
					// North West
					if ( x > 0 && y > 0 )
						if ( _cells[x-1][y-1].ok ) bros++;
					
					// South
					if ( y < _max )
						if ( _cells[x][y+1].ok ) bros++;
					
					// South East
					if ( x < _max && y < _max )
						if ( _cells[x+1][y+1].ok ) bros++;
					
					// South West
					if ( x > 0 && y < _max )
						if ( _cells[x-1][y+1].ok ) bros++;
					
					// East
					if ( x < _max )
						if ( _cells[x+1][y].ok ) bros++;
					
					// West
					if ( x > 0 )
						if ( _cells[x-1][y].ok ) bros++;

					if ( cell.ok )
					{
						switch( bros )
						{
							case 2 :
								cell.newState = Cell.ALIVE;
							break;
							
							case 3 :
								cell.newState = Cell.ALIVE;
							break;
							
							default :
								cell.newState = Cell.DEAD;
						}
						continue;
					}
					
					if ( bros == 3 )
					{
						cell.newState = Cell.SPAWN;
						continue;
					}
					
					cell.newState = Cell.EMPTY;
				}
			}
			
			for (x = 0; x < _segments; x++) 
			{
				for (y = 0; y < _segments; y++) 
				{
					cell = _cells[x][y];
					cell.state = cell.newState;
				}	
			}
			
			_generation++;
		}
		
		/**
		 * Clears the grid and sets each cell at random to either 'Alive' or 'Empty'
		 * @param	onProbability	The probability of any given cell being 'Alive'
		 */
		
		public function randomise( onProbability:Number = .2 ):void
		{
			for ( var x:int = 0; x < _segments; x++) 
			{
				for ( var y:int = 0; y < _segments; y++) 
				{
					var cell:Cell = _cells[x][y];
					cell.state = Math.random() < onProbability ? Cell.ALIVE : Cell.EMPTY;
				}	
			}
		}
		
		/**
		 * Resets the grid so that all cells are 'Empty'
		 */
		
		public function reset():void
		{
			_generation = 0;
			for ( var x:int = 0; x < _segments; x++) 
			{
				for ( var y:int = 0; y < _segments; y++) 
				{
					var cell:Cell = _cells[x][y];
					cell.state = Cell.EMPTY;
				}	
			}
		}
		
		/**
		 * Traces the current status of all cells in the grid
		 */
		
		public function save():void
		{
			var points:Array = new Array();
			
			for ( var x:int = 0; x < _segments; x++) 
			{
				for ( var y:int = 0; y < _segments; y++) 
				{
					var cell:Cell = _cells[x][y];
					points.push( cell.state );
				}	
			}
			
			trace(points);
		}
		
		/**
		 * Loads a preset configuration
		 * @param	points	An array of cell states corrosponding to each cell in the grid
		 */
		
		public function load( points:Array ):void
		{
			var i:int = _generation = 0;
			for ( var x:int = 0; x < _segments; x++) 
			{
				for ( var y:int = 0; y < _segments; y++) 
				{
					var cell:Cell = _cells[x][y];
					cell.state = points[i];
					i++;
				}	
			}
		}
		
		/*
		========================================================
		| Getters + Setters
		========================================================
		*/
		
		public function get generation():int { return _generation }
		
		/**
		 * Sets the dimensions of the grid and redraws it
		 */
		
		public function set size( size:int ):void
		{
			_size = size;
			calculateGrid();
			createGrid();
		}
		
		/**
		 * Sets the number of cells in each row and column and then redraws the grid
		 */
		
		public function set segments( segments:int ):void
		{
			_max = segments - 1;
			_segments = segments;
			calculateGrid();
			createGrid();
		}
		
	}
	
}

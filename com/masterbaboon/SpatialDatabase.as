package com.masterbaboon {
	
	import flash.display.DisplayObject;

	/**
	 * Spatial database to hold DisplayObjects elements on a grid.
	 * Useful for collision detection.
	 * 
	 * @author Pietro Berkes
	 */
	public class SpatialDatabase 
	{
		// instance of Grid used to store the elements
		protected var grid:Grid;
		// size of the physical space
		protected var phw:int;
		protected var phh:int;
		// size of grid elements in physical space units
		protected var sz:int;
		
		public function SpatialDatabase(w:int, h:int, sz:int) {
			phw = w;
			phh = h;
			this.sz = sz;
			grid = new Grid(Math.ceil(w / sz), Math.ceil(h / sz), false);
			
			/*
			 * init with empty arrays
			 * (I could use Dictionaries here, but as far as I understand,
			 * they lack basic methods to compute the size, or update them
			 * with other dictionaries, etc. which makes methods like
			 * getAllNeighbors quite ugly.)
			 */
			for (var i:int = 0; i < grid.getWidth(); i++) {
				for (var j:int = 0; j < grid.getHeigth(); j++) {
					grid.set(i, j, []);
				}
			}
		}
		
		/*
		 * Register visual element in the database
		 */
		public function register(s:DisplayObject):void {
			var arr:Array = grid.get(gi(s.x), gi(s.y));
			arr.push(s);
		}
		
		/*
		 * Return Array of elements registered at grid point defined
		 * by physical coordinates (x,y)
		 */
		public function query(x:int, y:int):Array {
			return grid.get(gi(x), gi(y));
		}
		
		/*
		 * Remove visual element from database
		 */
		public function remove(s:DisplayObject):void {
			var arr:Array = query(s.x, s.y);
			var idx:int = arr.indexOf(s);
			if (idx == -1) {
				throw new Error("Value " + String(s) + " not found at " + s.x + " " + s.y);
			}
			arr.splice(idx, 1);
		}
		
		/*
		 * Get all elements registered in a neighborhood of size 'size' at
		 * physical position (x,y).
		 */
		public function getAllNeighbors(x:int, y:int, size:int = 1):Array {
			return grid.reduceOnNeighbors(gi(x), gi(y), concatenate, size, true);
			
			function concatenate(arr1:Array, arr2:Array):Array {
				return arr1.concat(arr2);
			}
		}
		
		/*
		 * Return the index in the grid equivalent to spatial position x
		 */
		protected function gi(x:int):int {
			return Math.floor(x / sz);
		}
	}
	
}
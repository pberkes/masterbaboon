package com.masterbaboon {

	/**
	 * A Grid is a 2D Array where each element has a set of neighbors.
	 * 
	 * @author Pietro Berkes, masterbaboon.com
	 */
	public class Grid 
	{
		// VARIABLES
		// =========
		
		// 2D array storing the data
		protected var data:Array;
		// size of the grid
		protected var w:int;
		protected var h:int;
		// is the grid toroidal?
		protected var toroidal:Boolean;
		
		// CONSTRUCTOR
		// ===========
		
		public function Grid(w:int, h:int, toroidal:Boolean = false) {
			this.w = w;
			this.h = h;
			this.toroidal = toroidal;
			
			// create a 2D array of the right size
			data = new Array(w);
			for (var i:int = 0; i < w; i++) {
				data[i] = new Array(h);
			}
		}
		
		// GETTERS AND SETTERS
		// ===================
		
		public function getWidth():int { return w; }
		public function getHeigth():int { return h; }
		
		public function getToroidal():Boolean { return toroidal; }
		public function setToroidal(toroidal:Boolean):void {
			this.toroidal = toroidal;
		}
		
		// Return element of the grid
		public function get(x:int, y:int):* {
			return data[x][y];
		}
		
		// Set an element of the grid
		public function set(x:int, y:int, val:*):void {
			data[x][y] = val;
		}
		
		// METHODS
		// =======
		
		/*
		 * mapOnNeighbors calls fct(val) on all the neighbors of (x,y) and returns a list of the return values.
		 * @param size				size of the neighborhood
		 * @param includeCenter 	include also (x,y) in computation
		 */ 
		public function mapOnNeighbors(x:int, y:int, fct:Function, size:int = 1, includeCenter:Boolean = false):Array {
			var res:Array = new Array();
			
			for (var i:int = x - size; i <= x + size; i++) {
				for (var j:int = y - size; j <= y + size; j++) {
					if (!includeCenter && i == x && j == y) continue;
					if (toroidal) {
						res.push(fct(data[(i + w) % w][(j + h) % h]));
					} else {
						if (i >= 0 && i < w && j >= 0 && j < h) {
							res.push(fct(data[i][j]));
						}
					}
				}
			}
			
			return res;
		}
		
		/*
		 * reduceOnNeighbors(x, y, fct) returns a single value constructed by
		 * iterating over the neighbors of (x,y) and calling the function
		 * fct(a, b) on the first two items of the sequence, then on the
		 * result and the next item, and so on.
		 * 
		 * @param size				size of the neighborhood
		 * @param includeCenter 	include also (x,y) in computation
		 */
		public function reduceOnNeighbors(x:int, y:int, fct:Function, size:int = 1, includeCenter:Boolean = false):* {
			var res:* = undefined;
			var first:Boolean = true;
			
			for (var i:int = x - size; i <= x + size; i++) {
				for (var j:int = y - size; j <= y + size; j++) {
					if (!includeCenter && i == x && j == y) continue;
					if (toroidal) {
						// toroidal grid
						if (first) {
							res = data[(i + w) % w][(j + h) % h];
							first = false;
						} else {
							res = fct(res, data[(i + w) % w][(j + h) % h]);
						}
					} else {
						// hard boundaries
						if (i >= 0 && i < w && j >= 0 && j < h) {
							if (first) {
								res = data[i][j];
								first = false;
							} else {
								res = fct(res, data[i][j]);
							}
						}
					}
				}
			}
			
			return res;			
		}
		
		/*
		 * Get the values of the neighbors of (x,y) in a linear array.
		 * @param size				size of the neighborhood
		 * @param includeCenter 	include also (x,y)
		 */
		public function getNeighbors(x:int, y:int, size:int = 1, includeCenter:Boolean = false):Array {
			return mapOnNeighbors(x, y, identity, size, includeCenter);
			
			function identity(x:*):* {
				return x;
			}
		}

		/*
		 * Fill all elements of the grid with value val.
		 */
		public function fill(val:*):void {
			for (var i:int = 0; i < w; i++) {
				for (var j:int = 0; j < h; j++) {
					data[i][j] = val;
				}
			}
		}
	}
	
}
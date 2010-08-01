package 
{
	import de.polygonal.ds.Array2;
	import de.polygonal.ds.Iterator;
	import flash.display.Sprite;
	
	/**
	 * This class defines and updates a binary Cellular Automata.
	 * The survival and birth rules are defined in the arrays 'survival' and 'birth'.
	 * See http://en.wikipedia.org/wiki/Life-like_cellular_automaton for more deatils.
	 * @author Pietro Berkes
	 */
	public class BinaryCA extends Sprite 
	{
		// CONSTANTS
		// grid color
		protected const GRIDCOLOR:Number = 0xAAAAAA;
		
		// size of one of the squares in the grid
		protected var sizeSquare:int;
		// number of squares per dimension
		protected var nSquares:int;
		// space between grid lines and squares
		protected var padding:int;
		
		// the square's array; default are the Game of Life rules
		protected var squares:Array2;
		// an array of Boolean, used to store the next state of the CA
		protected var nextState:Array2;

		
		/*
		 * CA rules
		 * 'survival' and 'birth' are arrays of Booleans
		 */
		protected var survival:Array;
		protected var birth:Array;
		
		public function BinaryCA(nSquares:int, sizeSquare:int, padding:int = 1, border:int = 3) {
			this.nSquares = nSquares;
			this.sizeSquare = sizeSquare;
			this.padding = padding;
			nextState = new Array2(nSquares, nSquares);
			
			// draw grid
			var endPos:int = nSquares * sizeSquare;
			// background
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(-border, -border, endPos + 2*border, endPos + 2*border);
			// lines
			graphics.lineStyle(1, GRIDCOLOR);
			for (var x:int = 0; x <= endPos; x += sizeSquare ) {
				// vertical lines
				graphics.moveTo(0, x);
				graphics.lineTo(endPos, x);
				// horizontal lines
				graphics.moveTo(x, 0);
				graphics.lineTo(x, endPos);
			}
			
			// add squares
			var square:Square;
			var size:int = sizeSquare - (1 + 2 * padding);
			squares = new Array2(nSquares, nSquares);
			for (var i:int = 0; i < nSquares; i++) {
				for (var j:int = 0; j < nSquares; j++) {
					square = new Square(i * sizeSquare + padding + 1, j*sizeSquare + padding + 1, size);
					squares.set(i, j, square);
					addChild(square);
				}
			}
		}
		
		// reset CA with cells active at random
		public function randomFill(probActive:Number = 0.2):void {
			var iter:Iterator = squares.getIterator();
			
			iter.start();
			while (iter.hasNext()) {
				iter.data.setActive(Math.random() < probActive);
				iter.next();
			}
		}
		
		public function setRules(survival:Array = null, birth:Array = null) {
			if (survival) { this.survival = survival; }
			if (birth) { this.birth = birth; }
		}
		
		// reset CA to a blank state
		public function clear():void {
			var iter:Iterator = squares.getIterator();
			
			iter.start();
			while (iter.hasNext()) {
				iter.data.setActive(false);
				iter.next();
			}
		}
		
		// count how many of the neighbors surrounding (x,y) are active
		// the grid is toroidal
		public function countActiveNeighbors(x:int, y:int):int {
			// toroidal grid
			var nActives:int = 0;
			var ri:int, rj:int;
			for (var i:int = x - 1; i <= x + 1; i++) {
				ri = toroidalIndex(i);
				for (var j:int = y - 1; j <= y + 1; j++) {
					if (i == x && j == y) continue;
					rj = toroidalIndex(j);
					nActives += int(squares.get(ri, rj).getActive());
				}
			}
			return nActives;
			
			function toroidalIndex(i:int):int {
				return (nSquares + i) % nSquares;
			}
		}
		
		// update CA according to current rules
		public function update():void {		
			var isActive:Boolean;
			var nActives:int;
			
			// compute the next state of the CA
			for (var i:int = 0; i < nSquares; i++) {
				for (var j:int = 0; j < nSquares; j++) {
					isActive = squares.get(i, j).getActive();
					nActives = countActiveNeighbors(i, j);
					
					nextState.set(i, j, isActive);
					if (isActive) {
						// survival rule
						if (!survival[nActives])
							nextState.set(i, j, false);
					} else {
						// birth rule
						if (birth[nActives])
							nextState.set(i, j, true);
					}
				}
			}
			
			// update the squares
			var iterSquares:Iterator = squares.getIterator();
			var iterState:Iterator = nextState.getIterator();
			
			iterSquares.start();
			iterState.start();
			while (iterSquares.hasNext()) {
				iterSquares.data.setActive(iterState.data);
				iterSquares.next();
				iterState.next();
			}
		}
	}
}

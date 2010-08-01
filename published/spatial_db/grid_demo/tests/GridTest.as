package  
{
	import asunit.framework.TestCase;
	
	/**
	 * ...
	 * @author Pietro Berkes
	 */
	public class GridTest extends TestCase
	{
		protected var tgrid:Grid; // toroidal grid
		protected var grid:Grid; // non-toroidal grid
		
		public function GridTest(testMethod:String = null) {
			super(testMethod);
		}
		
		override protected function setUp():void {
			tgrid = new Grid(5, 5, true);
			grid = new Grid(5, 5, false);
			/*
			 * fill the grids with increasing integers from left to right, top to bottom
			 * the test grid is
			 *  0  1  2  3  4 
			 *  5  6  7  8  9
			 * 10 11 12 13 14
			 * 15 16 17 18 19
			 * 20 21 22 23 24
			 */
			var k:int = 0;
			for (var i:int = 0; i < 5; i++) {
				for (var j:int = 0; j < 5; j++) {
					tgrid.set(i, j, k);
					grid.set(i, j, k);
					k++;
				}
			}
		}
		
		protected function arraysEqual(a:Array, b:Array) {
			if (a.length != b.length) return false;
			if (a == b) return true;
			for (var i:int = 0; i < a.length; i++) {
				if (a[i] != b[i]) return false;
			}
			return true;
		}
		
		protected function assertArraysEqual(a:Array, b:Array) {
			var err:String = String(a) + " not equal to " + String(b)
			assertTrue(err, arraysEqual(a, b));
		}
		
		public function testGetNeighbors():void {
			var neighbors:Array;
			var expected:Array = [6, 7, 8, 11, 13, 16, 17, 18];
			
			// neighbors in the middle
			neighbors = tgrid.getNeighbors(2, 2, 1);
			assertArraysEqual(neighbors, expected);			
			neighbors = grid.getNeighbors(2, 2, 1);
			assertArraysEqual(neighbors, expected);
			
			// neighbors in a corner
			expected = [24, 20, 21, 4, 1, 9, 5, 6];
			neighbors = tgrid.getNeighbors(0, 0, 1);
			assertArraysEqual(neighbors, expected);			
			expected = [1, 5, 6];
			neighbors = grid.getNeighbors(0, 0, 1);
			assertArraysEqual(neighbors, expected);
			// include center
			expected = [0, 1, 5, 6];
			neighbors = grid.getNeighbors(0, 0, 1, true);
			assertArraysEqual(neighbors, expected);
			
			
			// larger neighborhood
			expected = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
			            13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
			neighbors = tgrid.getNeighbors(2, 2, 2);
			assertArraysEqual(neighbors, expected);			
			neighbors = grid.getNeighbors(2, 2, 2);
			assertArraysEqual(neighbors, expected);
		}
		
		public function testReduceNeighbors():void {
			var res:Number;
			res = tgrid.reduceOnNeighbors(0, 0, sum, 1, true);
			assertEquals(24+20+21+4+1+9+5+6, res);
			
			res = grid.reduceOnNeighbors(0, 0, sum, 1);
			assertEquals(1 + 5 + 6, res);
			
			function sum(a:Number, b:Number):Number { return a + b; }
		}
		
		public function testMapNeighbors():void {
			var expected:Array = [25, 21, 22, 5, 1, 2, 10, 6, 7];
			var res:Array = tgrid.mapOnNeighbors(0, 0, add1, 1, true);
			assertArraysEqual(res, expected);
			
			expected = [2, 6, 7];
			res = grid.mapOnNeighbors(0, 0, add1, 1);
			assertArraysEqual(res, expected);
			
			function add1(a:Number):Number { return a + 1; }
		}
	}
	
}
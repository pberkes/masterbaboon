package  
{
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * Class describing bugs.
	 * @author Pietro Berkes
	 */
	public class Bug extends Shape {
		
		// CONSTANTS
		// =========
		
		public static const RADIUS:int = 5;
		public static const SPEED:Number = 3;
		public static const MAX_ENERGY:int = 1500;
		public static const BACTERIUM_ENERGY:int = 40;

		protected const RADIANS_CONVERSION:Number = Math.PI / 180;
		protected const DEGREES_CONVERSION:Number = 180 / Math.PI;
		// FORWARD, SOFTRIGHT, HARDRIGHT, REVERSE, HARDLEFT, SOFTLEFT
		protected const TURN_ANGLES:Array = [0, 60, 120, 180, 240, 300];
		
		/*
		 * Turn array of integers into cumulative probability distribution
		 */
		public static function dnaRaw2CDF(dna_raw:Array):Array {
			// normalization term
			var sum:Number = 0;
			for (var i:int = 0; i < 6; i++) sum += Math.exp(dna_raw[i]);
			
			// normalize
			var dna_cdf:Array = new Array(6);
			var cumsum:Number = 0;
			for (i = 0; i < 6; i++) {
				cumsum += Math.exp(dna_raw[i]) / sum;
				dna_cdf[i] = cumsum;
			}
			return dna_cdf;
		}
		
		// VARIABLES
		// =========
		
		protected var age:int = 0;
		protected var energy:int;
		protected var generation:int;
		
		/*
		 * dna is an array with 6 elements:
		 * FORWARD, SOFTRIGHT, HARDRIGHT, REVERSE, HARDLEFT, SOFTLEFT
		 * dna_raw contains the raw integers
		 * dna_prob contains the equivalent probabilities
		 */
		protected var dna_raw:Array;
		protected var dna_cdf:Array;
		
		// color: red if energy is low, green for energy>=400
		protected var colorTransform:ColorTransform = new ColorTransform();
		
		// METHODS
		// =======
				
		public function Bug(x:int, y:int, dna:Array, energy:int = 100, generation:int = 0) {
			this.x = x;
			this.y = y;
			this.energy = energy;
			this.generation = generation;
			dna_raw = dna;
			dna_cdf = Bug.dnaRaw2CDF(dna);
			
			with (graphics) {
				lineStyle(1);
				beginFill(0x50FF00);
				drawCircle(0, 0, RADIUS);
				moveTo(0, 0);
				lineTo(0, -RADIUS);
			}
			
			// choose initial random direction
			rotation = Main.randomInt(6) * 60;
		}
		
		public function getEnergy():Number { return energy; }
		public function eat():void {
			energy = Math.min(energy + BACTERIUM_ENERGY, MAX_ENERGY);
		}
		
		public function getAge():Number { return age; }
		public function getDna():Array { return dna_raw; }
		public function getGeneration():int { return generation; }
		
		public function updatePos():void {
			// choose rotation from dna
			var idx:int = chooseRotation();
			
			// rotate
			rotation = (rotation + TURN_ANGLES[idx]) % 360;
			
			var speed_x:Number = SPEED * Math.sin(rotation*RADIANS_CONVERSION)
			var speed_y:Number = -SPEED * Math.cos(rotation*RADIANS_CONVERSION)
			x += speed_x;
			y += speed_y;
			
			// non-toroidal world
			x = Math.max(RADIUS, Math.min(Main.SIM_WIDTH-RADIUS, x));
			y = Math.max(RADIUS, Math.min(Main.SIM_HEIGHT-RADIUS, y));
			
			// update life statistics
			age++;
			energy--;
			
			// update color based on energy
			var clippedEnergy:Number = Math.min(400, energy)/400;
			colorTransform.alphaMultiplier = clippedEnergy*0.99 + 0.01;
			transform.colorTransform = colorTransform;
		}
		
		/*
		 * Return array of 2 children
		 */
		public function reproduce():Array {
			var children:Array = new Array(2);
			
			children[0] = new Bug(x, y, mutation(), energy / 2, generation + 1);
			children[1] = new Bug(x, y, mutation(), energy / 2, generation + 1);
			return children;
		}
		
		/*
		 * Return mutated dna
		 */
		protected function mutation():Array {
			var newDna:Array = dna_raw.slice();
			// select random mutation site
			var site:int = Main.randomInt(6);
			var delta:int = Main.randomInt(5) - 2;
			newDna[site] = Math.max(0, newDna[site] + delta);
			return newDna;
		}
		
		/*
		 * Choose index at random from distribution dna_cdf.
		 */
		protected function chooseRotation():int {
			var rand:Number = Math.random();
			var i:int = 0;
			while (dna_cdf[i] < rand) i++;
			return i;
		}

	}
	
}
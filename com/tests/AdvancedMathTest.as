package {
	import asunit.framework.TestCase;
	import com.masterbaboon.AdvancedMath;

	/**
	 * Tests for com.masterbaboon.AdvancedMath
	 * @author Pietro Berkes
	 */
	public class AdvancedMathTest extends TestCase {
		public function testSimpleStats():void {
			var x:Array = [1.2, 2.3, 3.4, 4.5, 5.6, 6.7];
			var res:Number;
			
			var xx:Array = [2.4, 4.6, 6.8, 9, 11.2, 13.4];
			assertArraysEqual(AdvancedMath.add(x, x), xx);
			res = AdvancedMath.sum(x);
			assertEqualsPrecision(res, 23.7, 9);
			res = AdvancedMath.mean(x);
			assertEqualsPrecision(res, 3.95, 9);
			res = AdvancedMath.variance(x);
			assertEqualsPrecision(res, 3.52916666667, 9);
		}
		
		public function testGamma():void {
			// for integers, Gamma(n) = (n-1)!
			assertEquals(AdvancedMath.gamma(5), 4*3*2);
			assertEquals(AdvancedMath.gamma(7), 6 * 5 * 4 * 3 * 2);
			// small floats
			assertEqualsPrecision(AdvancedMath.gamma(1.3), 0.89747069630627718, 9);
			assertEqualsPrecision(AdvancedMath.gamma(13.7), 2861595499.0660148, 9);
			assertEqualsPrecision(AdvancedMath.lnGamma(423.12), 2133.6594409871618, 9);
		}
		
		public function testFactorial():void {
			// test exact values
			assertEquals(AdvancedMath.factorial(0), 1);
			assertEquals(AdvancedMath.factorial(1), 1);
			// for cached values
			assertEquals(AdvancedMath.factorial(2), 2);
			assertEquals(AdvancedMath.factorial(5), 5*4*3*2);
			assertEquals(AdvancedMath.factorial(20), 2432902008176640000);
			// approximated values
			assertEqualsPrecision(AdvancedMath.factorial(50), 3.04140932e64, 9);
		}
		
		private function sampleGammaTest(k:Number, theta:Number, nsamples:int=50000) {
			// collect Gamma samples
			var samples:Array = new Array(nsamples);
			for (var i:int = 0; i < nsamples; i++) {
				samples[i] = AdvancedMath.sampleGamma(k, theta);
				// check that samples are positive
				assertTrue("Samples from Gamam have to be positive", samples[i] > 0);
			}
			// verify mean and variance
			assertEqualsPrecision(AdvancedMath.mean(samples), k * theta, 2);
			assertEqualsPrecision(AdvancedMath.variance(samples), k * theta * theta, 1);
		}
		
		public function testSampleGamma():void {
			sampleGammaTest(1, 1);
			sampleGammaTest(5.2, 1);
			sampleGammaTest(2.3, 7.6);
		}
		
		private function sampleDirichletTest(alpha:Array, nsamples:int = 25000):void {
			var k:int = alpha.length;
			var mn:Array = AdvancedMath.zeros(k, 0);
			var sample:Array;
			for (var i:int = 0; i < nsamples; i++) {
				sample = AdvancedMath.sampleDirichlet(alpha);
				if (i<100) assertEqualsFloat(AdvancedMath.sum(sample), 1, 9);
				mn = AdvancedMath.add(mn, sample);
			}
			
			// check mean of Dirichlet matches
			var alpha0:Number = AdvancedMath.sum(alpha);
			for (i = 0; i < k; i++) {
				assertEqualsFloat(mn[i] / nsamples, alpha[i]/alpha0, 0.01);
			}
			
			// check variance
			var expected:Number;
			for (i = 0; i < k; i++) {
				expected = alpha[i]*(alpha0 - alpha[i])/(alpha0*alpha0*(alpha0+1));
				assertEqualsFloat(mn[i] / nsamples, alpha[i]/alpha0, 0.01);
			}
		}
		
		public function testSampleDirichlet():void {
			sampleDirichletTest(AdvancedMath.zeros(10, 2.3));
			sampleDirichletTest([1.1, 5.4, 0.2, 0.3]);
		}
		
		public function testSampleMultinomial():void {
			var k:int = 7;
			var nsamples = 50000;
			var p:Array;
			var sample:int;
			var hist:Array;
			
			for (var i:int = 0; i < 5; i++) {
				hist = AdvancedMath.zeros(k);
				
				// select random probability distribution
				p = AdvancedMath.sampleDirichlet(AdvancedMath.zeros(k, 1));
				// sample from multinomial with probability distribution p
				for (var j:int = 0; j < nsamples; j++) {
					sample = AdvancedMath.sampleMultinomial(p);
					hist[sample] += 1;
				}
				
				// check that histogram corresponds to p
				for (j = 0; j < k; j++) {
					assertEqualsFloat(hist[j]/nsamples, p[j], 0.01);
				}
			}
		}
		
		public function testRandint():void {
			var nsamples = 50000;
			var hist:Array = AdvancedMath.zeros(12);
			var sample:Number;
			for (var i:int = 0; i < nsamples; i++) {
				sample = AdvancedMath.randint(2, 12);
				// check that it is integer
				assertEquals(Math.round(sample), sample);
				hist[sample]++;
			}
			
			// check that the indices outside the range are zero
			assertEquals(hist[0], 0);
			assertEquals(hist[1], 0);
			// the rest should have approx nsamples/10 numbers
			for (i = 0; i < 10; i++) {
				assertEqualsFloat(hist[sample]/nsamples, 0.1, 0.01);
			}
		}
		
		// ASSERTS
		// =======
		
		public function assertEqualsPrecision(x:Number, y:Number, significantDigits) {
			var err:String = "Expected " + x + " was " + y;
			assertTrue(err, Math.abs((x - y) / x) < Math.pow(10, -significantDigits));
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

	}
	
}
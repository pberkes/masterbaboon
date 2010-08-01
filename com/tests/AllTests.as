package {
	import asunit.framework.TestSuite;
	
	/**
	 * Run all tests
	 * @author Pietro Berkes
	 */
	public class AllTests extends TestSuite {
		public function AllTests() {
			super();
			addTest(new AdvancedMathTest());
		}
		
	}
	
}
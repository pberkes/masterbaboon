package  
{
	import asunit.framework.TestSuite;
	
	/**
	 * ...
	 * @author Pietro Berkes
	 */
	public class AllTests extends TestSuite
	{
		public function AllTests() {
			super();
			addTest(new GridTest());
		}
	}
	
}
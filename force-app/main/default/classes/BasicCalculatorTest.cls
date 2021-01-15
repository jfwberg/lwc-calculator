@IsTest
private class BasicCalculatorTest {
	
	// Test add
	private static testMethod void testAdd(){
		Decimal expected = 15;
		Decimal actual = BasicCalculator.add(10,5);
		
		System.assertEquals(expected, actual);
	}
	
	// Test subtract
	private static testMethod void testSubtract(){
		Decimal expected = 5;
		Decimal actual = BasicCalculator.subtract(10,5);
		
		System.assertEquals(expected, actual);
	}
	
	// Test devide
	private static testMethod void testDevide(){
		Decimal expected = 2;
		Decimal actual = BasicCalculator.devide(10,5);
		
		System.assertEquals(expected, actual);
	}
	
	// Test multiple
	private static testMethod void testMultiply(){
		Decimal expected = 50;
		Decimal actual = BasicCalculator.multiply(10,5);
		
		System.assertEquals(expected, actual);
	}
}
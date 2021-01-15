/**
 * @author		:	Justus van den Berg (jfwberg@gmail.com)
 * @date		:	2020-11-23:21:00
 * @description	:	Test class / method best practices example.
 *					This class tests the calculator LWC Apex controller.
 * @Tests		:	lwc_Calculator.apex (100% coverage)
 * @jira		:	JIRA-{12345678}, JIRA-{87654321}
 * @logicalTests:	TST-01 :: testAdd - Test calculator component add function
 *					TST-02 :: testSubtract 	- Test calculator component subtract function
 *					TST-03 :: testMultiply 	- Test calculator component multiply function
 *					TST-04 :: testDevide	- Test calculator component devide function
 *					TST-05 :: testDevideByZero - Test calculator devide exception when trying to devide by 0
 *					TST-06 :: testModulus - Test calculator component modulus function
 *					TST-07 :: testInvalidOperator - Test calculator component invalid operator scenario
 */
@IsTest(seeAlldata=false)
private with sharing class lwc_CalculatorTest {
	
	// Create a user for running the tests with
	private static User standardUserWithLwcCalculatorPermissionSet;
	
	// Lazy loading method
	private static User getStandardUserWithLwcCalculatorPermissionSet(){
		if(standardUserWithLwcCalculatorPermissionSet == null){
			standardUserWithLwcCalculatorPermissionSet = lwc_TestFactory.getRunningUser('Standard User', new String[]{'lwc_Calculator'});
		}
		return standardUserWithLwcCalculatorPermissionSet;
	}

	/**
	 *	Write simple test method ideally one per scenario where it makes sense, keep it nice and small
	 *	in case of this calculator, each operator is a clear example of a seperate case that can be tested
	 *	Give test methods logic names, let them describe what they are acutally testing, usually this is the method name
	 *
	 *	TST-01 :: 	testAdd - Test calculator component ADD(+) function
	 */
	private static testMethod void testAdd() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= 4.6;
			Decimal actual	= lwc_Calculator.excuteCalculation(1.2, 3.4, lwc_Calculator.Operator.ADD, true);
			String  message	= 'Unexpected value for add, expecting that 1.2 + 3.4 = 4.6';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Split out the expected / actual / message values into variables
	 *	This makes it easier to read, easier to maintain as well in case of logic changes
	 *
	 *	TST-02 :: 	testSubtract - Test calculator component SUBTRACT(-) function
	 */
	private static testMethod void testSubtract() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= -2.2;
			Decimal actual	= lwc_Calculator.excuteCalculation(1.2, 3.4, lwc_Calculator.Operator.SUBTRACT, true);
			String message	= 'Unexpected value for subtract, expecting that 1.2 - 3.4 = -2.2';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Add a message, every little bit of information helps
	 *	Nothing is as bad as a failed test class and no idea why or what it should do if you havent wrote the logic yourself
	 *
	 *	TST-03 :: 	testMultiply - Test calculator component MULTIPLY(*) function
	 */
	private static testMethod void testMultiply() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= 4.08;
			Decimal actual	= lwc_Calculator.excuteCalculation(1.2, 3.4, lwc_Calculator.Operator.MULTIPLY, true);
			String  message	= 'Unexpected value for multiply, expecting that 1.2 * 3.4 = 4.08';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Always test the happy path first
	 *
	 *	TST-04 :: testDevide - Test calculator component DEVIDE(/) function
	 */
	private static testMethod void testDevide() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= 5;
			Decimal actual	= lwc_Calculator.excuteCalculation(12.5, 2.5, lwc_Calculator.Operator.DEVIDE,true);
			String message	= 'Unexpected value for devide, expecting that 12.5 / 5 = 5';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Test edge cases and or the unhappy path, not just for coverage but for functionality
	 *	Keep the naming the same and add the edge case name
	 *
	 *	TST-05 :: 	testDevideByZero - Test calculator devide exception when trying to devide by 0
	 *				The calculator automatically return 0 in case of devision by 0
	 */
	private static testMethod void testDevideByZero() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= 0;
			Decimal actual	= lwc_Calculator.excuteCalculation(12.5, 0, lwc_Calculator.Operator.DEVIDE, true);
			String message	= 'Unexpected value for devide by zero';
			System.assertEquals(expected, actual, message);
		}
	}

	/**
	 *	Test the mod operator
	 *
	 *	TST-06 :: 	testModulus - Test calculator component MODULUS(%) function
	 */
	private static testMethod void testModulus() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			Decimal expected= 1;
			Decimal actual	= lwc_Calculator.excuteCalculation(10, 3, lwc_Calculator.Operator.MODULUS, true);
			String message	= 'Unexpected value for modulo, expecting that 10 % 3 = 1';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Test exceptions, by putting the error messages in custom labels or constants
	 *	Doing this you can catch the specific error and check the message matches the label, so the expected exception is thrown
	 *
	 *	TST-07 :: 	testInvalidOperator - Test calculator component INVALID operator scenario
	 */
	private static testMethod void testInvalidOperator() {
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			try{
				lwc_Calculator.excuteCalculation(1.2, 3.4, null, true);
			}catch(Exception e){
				String expected= lwc_Constant.INPUT_ERROR_MESSAGE;
				String actual	= e.getMessage();
				String message	= 'Unexpected error message for invalid operator';
				System.assertEquals(expected, actual, message);
			}
		}
	}

}
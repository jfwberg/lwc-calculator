/**
 * @author		:	Justus van den Berg (jfwberg@gmail.com)
 * @date		:	2020-11-23:21:00
 * @description	:	Test class / method best practices example.
 *					This class tests the calculator LWC Apex controller.
 * @Tests		:	lwc_Calculation.apex (100% coverage)
 * @jira		:	JIRA-{12345678}, JIRA-{87654321}
 * @logicalTests:	TST-08 :: testCalulationHistoryList - Test to fetch calculation history data from the database
 *					TST-09 :: testNoAccess - Test to ensure when the calculator permission set is removed, the calculator will not work
 *					TST-10 :: testNoAccessOnHistoryRecords - Test to ensure the user has access to the calculation history sObject
 *					TST-11 :: testBulkCalculationAndDataInsert - Test bulk insertion of data and triggers on the calculation history objects
 *
 *	Copyright (c) 2021 Justus van den Berg, info@aloha-workbench.com
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
@IsTest(seeAlldata=false)
 public with sharing class lwc_CalculationHistoryTest {

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
	 *	Setup common test data in a @TestSetup annotated method to share test data accross
	 *	test methods. Note that all data is reset to a checkpoint between methods.
	 */
	@testSetup
	private static void setupTestData() {

		// Create some test data for the calculation history as our current running user
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			lwc_Calculator_History__c[] calculationHistory = new lwc_Calculator_History__c[]{};
			calculationHistory.add(new lwc_Calculator_History__c( Number_A__c = 1,	Number_B__c = 2, Operator__c = 'ADD', 		Result__c = 3 	));
			calculationHistory.add(new lwc_Calculator_History__c( Number_A__c = 1,	Number_B__c = 2, Operator__c = 'SUBTRACT',	Result__c = -1	));
			calculationHistory.add(new lwc_Calculator_History__c( Number_A__c = 1,	Number_B__c = 2, Operator__c = 'MULTIPLY',	Result__c =	2	));
			calculationHistory.add(new lwc_Calculator_History__c( Number_A__c = 1,	Number_B__c = 2, Operator__c = 'DEVIDE',	Result__c = 0.5	));
			calculationHistory.add(new lwc_Calculator_History__c( Number_A__c = 10,	Number_B__c = 3, Operator__c = 'MODULUS',	Result__c = 1	));
			insert calculationHistory;
		}
	}

	/**
	 *	Test expected number of records when working with queries
	 *
	 *	TST-08 :: testCalulationHistoryList - Test to fetch calculation history data from the database
	 */
	private static testMethod void testCalulationHistoryList(){
		
		// Setup the test data
		setupTestData();
		
		// Set the running user
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){

			// Test start and test stops resets our govenor limits
			System.Test.startTest();
			lwc_Calculator_History__c[] calculationHistory = lwc_CalculationHistory.getCalulationHistoryList();
			System.Test.stopTest();

			// Validate our test
			Decimal expected = 5;
			Decimal actual	= calculationHistory.size();
			String message	= 'Unexpected number of calculation history records';
			System.assertEquals(expected, actual, message);
		}
	}


	/**
	 *	Test exceptions, by putting the error messages in custom labels or constants
	 *	Doing this you can catch the specific error and check the message matches the label, so the expected exception is thrown
	 *
	 *	TST-09 :: 	testNoAccess - Test to ensure when the calculator permission set is removed, the calculator will not work
	 */
	private static testMethod void testNoAccess() {
		
		// Delete permission set from our test user so access has been removed
		delete [
			SELECT
				Id
			FROM
				PermissionSetAssignment 
			WHERE
				AssigneeId = :getStandardUserWithLwcCalculatorPermissionSet().Id AND 
				PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile = false )
		];
		
		// Now run logic without the proper permissions and check we get an error exception
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			try{
				lwc_Calculator.excuteCalculation(1.2, 3.4, lwc_Calculator.Operator.ADD, true);
			}catch(Exception e){
				String expected= lwc_Constant.CALC_HIS_NO_RC_MESSAGE;
				String actual	= e.getMessage();
				String message	= 'Unexpected error message for no read / create access';
				System.assertEquals(expected, actual, message);
			}
		}
	}


	/**
	 *	Access will now been removed so there should be no records and we can test our final error scenario
	 *
	 *	TST-10 :: 	testNoAccessOnHistoryRecords - Test to ensure the user has access to the calculation history sObject
	 */
	private static testMethod void testNoAccessOnHistoryRecords() {
		
		// Delete permission set from our test user
		delete [
			SELECT
				Id
			FROM
				PermissionSetAssignment 
			WHERE
				AssigneeId = :getStandardUserWithLwcCalculatorPermissionSet().Id AND 
				PermissionSetId IN (SELECT Id FROM PermissionSet WHERE IsOwnedByProfile = false )
		];

		// Now run logic without the proper permissions and check we get an error exception
		System.runAs(getStandardUserWithLwcCalculatorPermissionSet()){
			try{
				System.Test.startTest();
				lwc_Calculator_History__c[] calculationHistory = lwc_CalculationHistory.getCalulationHistoryList();
				System.Test.stopTest();
			}catch(Exception e){
				String expected= lwc_Constant.CALC_HIS_NO_R_MESSAGE;
				String actual	= e.getMessage();
				String message	= 'Unexpected error message for no read access';
				System.assertEquals(expected, actual, message);
			}
		}
	}
	

	/**
	 *	Always test data creation in bulk to test triggers
	 *	This will test the validation rules on top of the Calculation history
	 *
	 *	TST-11 :: testBulkCalculationAndDataInsert - Test bulk insertion of data and triggers on the calculation history objects
	 */
	private static testMethod void testBulkCalculationAndDataInsert(){
		
		// List of operators so we can do some random calculations in bulk
		lwc_Calculator.Operator[] operators = new lwc_Calculator.Operator[]{
			lwc_Calculator.Operator.ADD,
			lwc_Calculator.Operator.SUBTRACT,
			lwc_Calculator.Operator.DEVIDE,
			lwc_Calculator.Operator.MULTIPLY,
			lwc_Calculator.Operator.MODULUS
		};

		// Delete any calculation history created by the test data method, just to be sure there are no records when we start
		delete [SELECT Id FROM lwc_Calculator_History__c];
		
		// Reset govenor limits
		Test.startTest();

		// Let's create 500 records by executing 500 random calculations
		for(Integer i=0; i<500; i++){
			
			// Generate some random numbers
			Integer randomNumberForOperator = Integer.valueof((Math.random() *  4));
			Integer randomNumberForA 		= Integer.valueof((Math.random() * 25) + 1);
			Integer randomNumberForB 		= Integer.valueof((Math.random() * 25));

			// Create new calculation history records
			lwc_Calculator.excuteCalculation(
				randomNumberForA,
				randomNumberForB,
				operators[randomNumberForOperator],
				false
			);
		}
		
		// Save te 500 history records at once to test the triggers in bulk
		lwc_CalculationHistory.saveHistoryRecords();

		// Stop the test
		Test.stopTest();

		// Validate the bulk result
		Integer expected= 500;
		Integer actual	= [SELECT COUNT() FROM lwc_Calculator_History__c];
		String  message	= 'Unexpected number of records created';
		System.assertEquals(expected, actual, message);
	}
}
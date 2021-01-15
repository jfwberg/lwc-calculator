/**
 * @author		:	Justus van den Berg
 * @date		:	2020-05-21
 * @description	:	This class is really bad and only tests coverage
 */
@IsTest
public with sharing class lwc_CalculatorTestBad {
	
	/**
	 * Single test method to illustrate how 100% coverage can be achieved
	 * but nothing is acutally tested
	 */
	private static testMethod void getCalculatorCoverage(){

		// "Test" calculation happy paths
		lwc_Calculator.excuteCalculation(1,1,lwc_Calculator.Operator.ADD, true);
		lwc_Calculator.excuteCalculation(1,1,lwc_Calculator.Operator.SUBTRACT, true);
		lwc_Calculator.excuteCalculation(1,1,lwc_Calculator.Operator.MULTIPLY, true);
		lwc_Calculator.excuteCalculation(1,1,lwc_Calculator.Operator.DEVIDE, true);
		lwc_Calculator.excuteCalculation(1,1,lwc_Calculator.Operator.MODULUS, true);

		// "Test the exceptions"
		try{lwc_Calculator.excuteCalculation(1,1,null,true);}catch(Exception e){System.debug('Do nothing');}
		try{lwc_Calculator.excuteCalculation(1,0,lwc_Calculator.Operator.DEVIDE,true);}catch(Exception e){System.debug('Do nothing');}

		// Lwc method
		lwc_Calculator.excuteCalculationFromLwc(1,1,'ADD');
	}
	
	 /**
	 * Single test method to illustrate how 100% coverage can be achieved
	 * but nothing is acutally tested
	 */
	private static testMethod void getCalculationHistoryCoverage(){
		// Test that we have some data
		lwc_CalculationHistory.addHistoryRecord(1, 2, 'ADD', 3);
		lwc_CalculationHistory.saveHistoryRecords();
		lwc_CalculationHistory.getCalulationHistoryList();
	}
	

	/**
	 * 	Method to get some test coverage for the lwc_Calculator_History__c trigger to get code coverage
	 */
	private static testMethod void getCoverageForTriggers(){
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=2,Operator__c='ADD');		}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=2,Operator__c='SUBTRACT');}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=2,Operator__c='MULTIPLY');}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=2,Operator__c='DEVIDE');	}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=0,Operator__c='DEVIDE');	}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=5,Operator__c='MODULUS');	}catch(Exception e){System.debug('Do nothing');}
		try{insert new lwc_Calculator_History__c(Number_A__c = 1, Number_B__c=5,Operator__c='INVALID');	}catch(Exception e){System.debug('Do nothing');}
	}
}
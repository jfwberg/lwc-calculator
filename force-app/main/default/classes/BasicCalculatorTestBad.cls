@IsTest
private with sharing class BasicCalculatorTestBad {
     // Get code coverage for BasicCalculator class
	 private static testMethod void getCodeCoverage(){
        BasicCalculator.add(1,1);
        BasicCalculator.subtract(1,1);
        BasicCalculator.multiply(1,1);
        BasicCalculator.devide(1,1);
    }
}

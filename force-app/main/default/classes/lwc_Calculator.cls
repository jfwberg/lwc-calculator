/**
 * @author		:	Justus van den Berg
 * @description	:	Basic calculator class for LWC Testing
 * @date		:	2020-05-21
 */
public with sharing class lwc_Calculator {
	
	// Operators this calculator can handle + - * / %
	public Enum Operator {ADD, SUBTRACT, MULTIPLY, DEVIDE, MODULUS}

	/**
	 * An overly complicated calculation method for demo purposes and LWC Joy
	 */
	public static Decimal excuteCalculation(Decimal a, Decimal b, Operator operator, Boolean saveHistoryRecordDirectly){
		
		// Validate method inputs are not empty and operator exist in Operator ENUM
		if(a == null || b == null || operator == null ){
			throw new lwc_Exception(lwc_Constant.INPUT_ERROR_MESSAGE);
		}
		
		// Variable to hold the result that we're going to output
		Decimal result = 0;

		// Validate calculations
		switch on operator {

			when ADD {
				result = a+b;
			}

			when SUBTRACT {
				result =  a-b;
			}

			when MULTIPLY {
				result =  a*b;
			}

			when DEVIDE {
				result = (b == 0)?0:(a/b);
			}

			when MODULUS {
				result = Math.mod(Integer.valueOf(a), Integer.valueOf(b));
			}
		}

		// Create a history record for this calculation
		lwc_CalculationHistory.addHistoryRecord(a,b,operator.name(),result);

		// Check if the history record needs to be saved directly, can be used for single calculations
		if(saveHistoryRecordDirectly){
			lwc_CalculationHistory.saveHistoryRecords();
		}
		
		// Return the result
		return result;		
	}


	/**
	 * Method overload for defaulting to true for saving records
	 */
	@AuraEnabled
	public static Decimal excuteCalculationFromLwc(Decimal a, Decimal b, String operator){
		Map<String,Operator> operatorMap = new Map<String,Operator>{
			'ADD'		=> lwc_Calculator.Operator.ADD,
			'SUBTRACT'	=> lwc_Calculator.Operator.SUBTRACT,
			'MULTIPLY'	=> lwc_Calculator.Operator.MULTIPLY,
			'DEVIDE'	=> lwc_Calculator.Operator.DEVIDE,
			'MODULUS'	=> lwc_Calculator.Operator.MODULUS
		};
		return excuteCalculation(a, b, operatorMap.get(operator), true);
	}
	
}
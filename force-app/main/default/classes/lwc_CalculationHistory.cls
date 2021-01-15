public with sharing class lwc_CalculationHistory {
	
	// List for holding the calculator history records
	public static lwc_Calculator_History__c[] calculatorHistoryRecords = new lwc_Calculator_History__c[]{};


	/**
	 * Method for adding a calculation history record to the list
	 */
	public static void addHistoryRecord(Decimal a, Decimal b, String operator, Decimal result){
		
		// Check if the user has read and create access on the history object
		if(Schema.sObjectType.lwc_Calculator_History__c.isAccessible() && Schema.sObjectType.lwc_Calculator_History__c.isCreateable()){
			
			// Create a new history record
			calculatorHistoryRecords.add(
				new lwc_Calculator_History__c(
					Number_A__c = a,
					Number_B__c = b,
					Operator__c = operator,
					Result__c	= result
				)
			);
		}else{
			throw new lwc_Exception(lwc_Constant.CALC_HIS_NO_RC_MESSAGE);
		}
	}


	/**
	 *	Method to insert the calculation history records
	 */
	public static void saveHistoryRecords(){
		database.insert(calculatorHistoryRecords,false);
	}


	/**
	 *	Method to get the current user's calculation history
	 */
	@AuraEnabled
	public static lwc_Calculator_History__c[] getCalulationHistoryList(){
		
		// Check if the current user can access the lwc_Calculator_History__c object
		if(Schema.sObjectType.lwc_Calculator_History__c.isAccessible()){
			
			// Return the last 10 history records for the current user
			return [
				SELECT 
					CreatedDate, Number_A__c, Number_B__c, Operator__c, Result__c
				FROM 
						lwc_Calculator_History__c 
				WHERE 
					CreatedById = :UserInfo.getUserId()
				ORDER BY 
					CreatedDate DESC 
				LIMIT 10
			];
		}else{
			throw new lwc_Exception(lwc_Constant.CALC_HIS_NO_R_MESSAGE);
		}
	}

}

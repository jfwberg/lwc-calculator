trigger CalculationHistoryTrigger on lwc_Calculator_History__c (before insert, before update) {

	/**
	 *	Check before insert or update
	 */
	for(Integer i=0, max=trigger.new.size();i<max;i++){

		// Extract values from the trigger for easy reading
		Decimal a = trigger.new[i].Number_A__c;
		Decimal b = trigger.new[i].Number_B__c;
		Decimal c = trigger.new[i].Result__c;
        String  o = trigger.new[i].Operator__c;

		// Validate calculations
		switch on trigger.new[i].Operator__c {
			when 'ADD' {
				if(a+b != c){
					addError(trigger.new[i],a,b,c,o);
					break;
				}
			}	
			when 'SUBTRACT' {		
				if(a-b != c){
					addError(trigger.new[i],a,b,c,o);
					break;
				}
			}
			when 'MULTIPLY' {
				if(a*b != c){
					addError(trigger.new[i],a,b,c,o);
					break;
				}
			}
			when 'DEVIDE' {
                if(b == 0 && c != 0){
					addError(trigger.new[i],a,b,c,o);
					break;
				}else if(b != 0){
					if(a/b != c){
						addError(trigger.new[i],a,b,c,o);
						break;
					}
				}
			}
			when 'MODULUS' {
				if(Math.mod(Integer.valueOf(a), Integer.valueOf(b)) != c){
					addError(trigger.new[i],a,b,c,o);
					break;
				}
			}
		}
	}

    
	/**
	 *	Method for adding a error string with the details
	 */
	void addError(lwc_Calculator_History__c record, Decimal a, Decimal b, Decimal c, String operator){
		record.addError(
			String.format('{0} {1} {2} != {3}',
				new String[]{
					String.valueOf(a),
					operator,
					String.valueOf(b),
					String.valueOf(c)
				}
			)
		);
	}
}
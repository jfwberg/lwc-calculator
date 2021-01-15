import { LightningElement, track, wire }from 'lwc';
import { CurrentPageReference }			from 'lightning/navigation';
import { fireEvent }					from 'c/pubsub';
import excuteCalculationFromLwc			from '@salesforce/apex/lwc_Calculator.excuteCalculationFromLwc';

export default class Lwc_Calculator extends LightningElement {
	
	// Create page reference
	@wire(CurrentPageReference) pageRef;

	// Variable for holding error messages
	error;
	errorMessage;

	// Switch between the first and second input
	selectedNumber = 1;
	
	// An array to key in different numbers with multiple button clicks
	tempNumbArr = [];

	// Calculation values
	@track numA = 0;
	@track numB = 0;
	@track result = 0;
	@track operator = 'ADD';
	@track displayValue = 0;
	
	/**
	 * Method for handling the click of a button
	 */
	handleClick(event){
		try{
			// Define button values to actions
			const actionInputs   = ['AC', 'C', '='];
			const numberInputs   = ['1', '2', '3', '4', '5', '6', '7', '8', '9','0','.'];
			const operatorInputs = ['ADD', 'SUBTRACT', 'MULTIPLY', 'DEVIDE', 'MODULUS'];

			// NUMBER INPUTS
			if(numberInputs.includes(event.target.value)){
				
				// Check a . can only be added once
				if(event.target.value === '.'){
					if(!this.tempNumbArr.includes('.')){
						this.tempNumbArr.push(event.target.value);
					}
				}else{
					this.tempNumbArr.push(event.target.value);
				}
				
				// Set the correct number
				if(this.selectedNumber === 1){
					this.numA = parseFloat(this.tempNumbArr.join(''));
				}else{
					this.numB = parseFloat(this.tempNumbArr.join(''));
				}
				this.displayValue = parseFloat(this.tempNumbArr.join(''));

				// Reset the results
				this.resetResult();
			
			// OPERATOR INPUTS
			}else if(operatorInputs.includes(event.target.value)){
				
				// Set the operator, switch to number 2, rest the temp value array and reset the second number
				if(this.selectedNumber === 1 && this.numA !== 0){
					this.operator = event.target.value;
					this.selectedNumber = 2;					
					this.resetNumB();
					this.resetResult();
				}else if(this.selectedNumber === 2){
					this.operator = event.target.value;
				}

			// ACTION INPUTS
			}else if(actionInputs.includes(event.target.value)){
				
				// Clear all
				if(event.target.value === 'AC'){

					this.resetAllNumbers();
					this.resetResult();
					this.resetDisplayValue();
				
				// Clear current number
				}else if(event.target.value === 'C'){
					if(this.selectedNumber === 1){
						this.resetNumA();
					}else{
						this.resetNumB();	
					}
					this.resetResult();
					this.resetDisplayValue();

				// Execute calculation
				}else if(event.target.value === '='){
					this.calculate();
					this.resetAllNumbers();
				}
			}
		}catch(error){
			// Set error message
			this.errorMessage = error.message;
		}
	}

	calculate(){
		excuteCalculationFromLwc({ a : this.numA, b : this.numB, operator : this.operator})
            .then((result) => {
                this.result = result;
				this.error = undefined;
				this.displayValue = this.result;
				
				
				// Set number A so we can continue calculating
				this.numA = result;
				
				// Fire an event to update the history table
				fireEvent(this.pageRef, 'calculationExecuted', result);
            })
            .catch((error) => {
                this.error = error;
				this.result = 0;
				this.displayValue = this.result
			});
	}

	resetNumA(){
		this.numA = 0;
		this.tempNumbArr = [];
	}

	resetNumB(){
		this.numB = 0;
		this.tempNumbArr = [];
	}

	resetAllNumbers(){
		this.numA = 0;
		this.numB = 0;
		this.selectedNumber = 1;
		this.tempNumbArr = [];
	}

	resetDisplayValue(){
		this.displayValue = 0;
	}
	
	resetResult(){
		this.result = 0;
	}

	get operatorCharacter(){
		const operatorMap = {
			'ADD'       : '+',
			'SUBTRACT'  : '-',
			'MULTIPLY'  : '*',
			'DEVIDE'    : '/',
			'MODULUS'   : '%'
		}
		return operatorMap[this.operator];
	}
}
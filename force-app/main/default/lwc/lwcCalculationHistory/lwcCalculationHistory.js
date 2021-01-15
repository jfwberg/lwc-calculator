import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import getCalulationHistoryList from '@salesforce/apex/lwc_CalculationHistory.getCalulationHistoryList';

export default class LwcCalculationHistory extends LightningElement {
    
    error;
    calculationHistoryList;
    @wire(CurrentPageReference) pageRef;

    connectedCallback(){

        // subscribe to calculationExecuted event
        registerListener('calculationExecuted', this.fetchCalculationHistoryListFromApex, this);

        // Get the history list
        this.fetchCalculationHistoryListFromApex();
    }

    disconnectedCallback() {
        // unsubscribe from calculationExecuted event
        unregisterAllListeners(this);
    }

    fetchCalculationHistoryListFromApex(){
        getCalulationHistoryList()
            .then((result) => {
                this.error = undefined;
                this.calculationHistoryList = result;
            })
            .catch((error) => {
                this.error = error;
                this.calculationHistoryList = [];
            });
    }

}
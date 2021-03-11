import { LightningElement, api, track } from 'lwc';
import getParticipants from '@salesforce/apex/AddParticipantsController.getParticipants';
import setParticipants from '@salesforce/apex/AddParticipantsController.setParticipants';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class AddParticipantsLwc extends LightningElement {
    @api recordId;
    @api opp;

    @track participants;

    connectedCallback() {      
        console.log(this.recordId);  
        getParticipants({ oppId : this.recordId })
            .then(result => {
                this.opp = result.opp;

                let arr = new Array();
                for (var i = 0; i < result.opp.Participants_quantity__c; i++) {
                    arr.push( {operator : 'i_' + i} );
                }

                this.participants = arr;
            }).catch(error => {
                console.log(error);
            });
    }

    submitFields(event) {
        event.preventDefault();
        let elArr = new Array();
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            elArr.push(element.value);
        });
        
        var hasNull = false;
        
        elArr.forEach(el => {
            if(el == null || el === null) {
                console.log('el = ' + el);
                hasNull = true;
            }
        });
    
        if(hasNull) {
            this.dispatchEvent(
                new ShowToastEvent({
                    "title": "Error!",
                    "variant" : "error",
                    "message": "Fill every contact"
                })
            );
    
            return;
        }
        
        setParticipants({ 
            oppId : this.recordId,
            trainingId : this.opp.Training__c,
            contactsAsStrings : elArr 
        })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "Participants are in training"
                })
            );

            this.closeSucc(); 
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    "title": "Error!",
                    "variant" : "error",
                    "message": error.body.message
                })
            );

            this.closeError(error); 
        }); 

        
    }

    closeSucc() {
        this.dispatchEvent(new CustomEvent('success', {detail: 'close quick action'}));
    }

    closeError(error) {
        this.dispatchEvent(new CustomEvent('error', {detail: error}));
    }
}
import { LightningElement, track, api } from 'lwc';
import closeOppFromController from '@salesforce/apex/CloseOppController.closeOppFromController';

export default class CloseOpportunity extends LightningElement {
    @api recordId;
    @track type = 'won';
    @track showAddPart = false; 

    typeSelection(event) {
        this.type = event.detail.value;
    }

    nextStep() {
        console.log('nextStep');
        console.log(this.type);

        if(this.type === 'won') {
            this.showAddPart = true;
        } else {            
            this.closeOpp();
        }
    }

    closeOpp(event) {
        closeOppFromController({
            status: this.type,
            oppId: this.recordId
        })
        .then(() => {
            this.closeOpp();
        })
        .catch((error) => {
            this.closeOpp();
                console.log(error);
        });
        this.dispatchEvent(new CustomEvent('close'));
    }

    updateOpp() {
        console.log('updateOpp');
        closeOppFromController({
            status: this.type,
            oppId: this.recordId
        })
            .then(() => {
                
            })
            .catch((error) => {
                console.log(error);
            });
    }

    showError(err) {
        console.log('showError');
        
    }

    get typeOptions() {
        return [
            {label: 'Closed Won', value: 'won'},
            {label: 'Closed Lost', value: 'lost'}
        ];
    }
}
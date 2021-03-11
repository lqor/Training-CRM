import { LightningElement, wire, api } from 'lwc';
import getParticipantsByTaskId from '@salesforce/apex/CreateTaskAfterTraining.getParticipantsByTaskId';
import { updateRecord } from 'lightning/uiRecordApi';
import GPA_FIELD from '@salesforce/schema/Participant__c.GPA__c';
import ID_FIELD from '@salesforce/schema/Participant__c.Id';
import { refreshApex } from '@salesforce/apex';
import CONTACT_NAME_FIELD from "@salesforce/schema/Participant__c.Contact__r.Name";
import CONTACT_FIELD_c from "@salesforce/schema/Participant__c.Contact__c";
import PART_NAME_FIELD from "@salesforce/schema/Participant__c.Name";

export default class FillGPALwc extends LightningElement {
    @api recordId;

    @wire (getParticipantsByTaskId, { taskId: '$recordId' } ) participants;

    handleSubmit(event) {
        for (let index = 0; index < this.participants.data.length; index++) {
            const fields = {};

            fields[ID_FIELD.fieldApiName] = this.participants.data[index].Id;
            const queryStr = "[data-index='" + index + "']"; 
            fields[GPA_FIELD.fieldApiName] = this.template.querySelector(queryStr).value;

            const recordInput = { fields };

            updateRecord(recordInput)
                .then(() => {             
                    return refreshApex(this.participants);
                })
                .catch(error => {
                    console.log('Error: ' + error);
                });
        }
        
        this.handleCancel();
    }

    handleCancel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }
}
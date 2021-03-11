import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class DefinePartAndTrainingLwc extends LightningElement {
    @api recordId;

    close() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}
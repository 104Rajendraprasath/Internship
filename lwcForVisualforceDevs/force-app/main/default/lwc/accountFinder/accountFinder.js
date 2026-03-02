import { LightningElement, wire } from 'lwc';
import queryAccountsByRevenue from '@salesforce/apex/AccountListControllerLwc.queryAccountsByRevenue';

export default class AccountFinder extends LightningElement {
    @wire(queryAccountsByRevenue, { annualRevenue: '$annualRevenue' })
    accounts;
    // Initialize property to null
    annualRevenue = null;

    // Event handler for the input field
    handleChange(event) {
        this.annualRevenue = event.detail.value;
    }

    // Event handler for the reset button
    reset() {
        this.annualRevenue = null;
    }
}
import { LightningElement, wire } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';
import GET_CONTACTS from '@salesforce/apex/ContactController.getContacts';

export default class ContactList extends LightningElement {
    @wire(GET_CONTACTS)
    contacts;

    // This getter is MANDATORY for the challenge
    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}
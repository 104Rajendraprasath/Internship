import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Import references to the Contact object and its fields
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class ContactCreator extends LightningElement {
    // Define the object API name for the lightning-record-form
    objectApiName = CONTACT_OBJECT;

    // Define the list of fields to display
    fields = [FIRST_NAME_FIELD, LAST_NAME_FIELD, EMAIL_FIELD];

    // Event handler for the 'onsuccess' event
    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "Contact created",
            // event.detail.id holds the Id of the newly created record
            message: "Record ID: " + event.detail.id, 
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}
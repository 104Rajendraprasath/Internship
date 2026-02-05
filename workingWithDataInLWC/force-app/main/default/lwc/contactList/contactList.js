import { LightningElement, wire } from 'lwc';

// 1. Import the Apex method: @salesforce/apex/ClassName.methodName
import getContacts from '@salesforce/apex/ContactController.getContacts';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

// 2. Define the columns for the lightning-datatable
const COLUMNS = [
    // fieldName must match the API name in the Apex query (FirstName)
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];

export default class ContactList extends LightningElement {
    // 3. Assign the column array to a property
    columns = COLUMNS;
    
    // 4. Wire the Apex method to the 'contacts' property
    // Since getContacts has no parameters, we just pass the function name
    @wire(getContacts)
    contacts; // The data will be in contacts.data or contacts.error
     get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}
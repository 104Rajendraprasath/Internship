import { LightningElement } from 'lwc';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class HelloWorld extends LightningElement {
   
    fields=[NAME_FIELD,EMAIL_FIELD];
    objectApiName=CONTACT_OBJECT;
    
    handleButtonClick(event) {
        this.capsValue = event.detail;
        
    }
    
}
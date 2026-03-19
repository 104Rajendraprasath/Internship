import { LightningElement } from 'lwc';

export default class ChildComponent extends LightningElement {
    handleClick() {
        //alert('Button in Child Component Clicked!');
        this.dispatchEvent(new CustomEvent('buttonclick', { detail: 'Button in Child Component Clicked!' }));
    }
}
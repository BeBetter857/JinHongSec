import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class quickLwc extends LightningElement {
    @api recordId;
    @api objectApiName;

    connectedCallback() {
        window.open('https://onilab.com/blog/scratch-org-from-shape-org-guide', '_blank', "toolbar=0,location=0,menubar=0")
        setTimeout(() => {
            this.closeAction()
        }, 500)
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}
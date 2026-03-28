import { LightningElement, api } from 'lwc';
import ensxtx_CartPDP_Field_DateAvailable from '@salesforce/label/c.ensxtx_CartPDP_Field_DateAvailable';
import ensxtx_CartPDP_Table_Date from '@salesforce/label/c.ensxtx_CartPDP_Table_Date';
import ensxtx_CartPDP_Table_QtyAvailable from '@salesforce/label/c.ensxtx_CartPDP_Table_QtyAvailable';

export default class EnsxtxProductAvailabilityDates extends LightningElement {
    @api availabilities;

    label = {
        ensxtx_CartPDP_Field_DateAvailable,
        ensxtx_CartPDP_Table_Date,
        ensxtx_CartPDP_Table_QtyAvailable
    };

    async connectedCallback() {
        if (!this.availabilities || !this.availabilities.length) {
            this.multipleDates = false;
            this.availableDate = "";
            this.availabilities = [];
        } else {
            if (this.availabilities.length === 1){
                this.availableDate = this.availabilities[0].ScheduleLineDate;
                this.multipleDates = false;
            } else {
                this.multipleDates = true;
            }
        }
    }
}
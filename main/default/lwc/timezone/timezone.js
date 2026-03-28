import { LightningElement, track,api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UpdateServiceAppointment extends LightningElement {
    @api recordId;
    @track startTime;
    @track endTime;

    handleIdChange(event) {
        this.recordId = event.target.value;
    }

    handleStartTimeChange(event) {
        this.startTime = this.convertToGMT(event.target.value);
    }

    handleEndTimeChange(event) {
        this.endTime = this.convertToGMT(event.target.value);
    }

   convertToGMT(dateTime) {
        // Convert the date time from Eastern Time to GMT
        let date = new Date(dateTime);
        date.setHours(date.getHours() - 5); // Eastern Time is GMT-4
        return date.toISOString();
    }

    updateRecord() {
        const fields = {};
        fields['Id'] = this.recordId;
        fields['SchedStartTime'] = this.startTime;
        fields['SchedEndTime'] = this.endTime;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record updated',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AddCommentsTimeSheet extends LightningElement {
isShowCommentsModal = false;
@api commentsValue=''
@api timeSheetRecordId;
@api disabled;


    showCommentsModal(){
        this.isShowCommentsModal = true;
    }

    closeCommentsModal(){
        this.isShowCommentsModal = false;
    }

    handleComments(event) {
        this.commentsValue = event.detail.value
    }
    submitComments() {

        this.isShowCommentsModal = false

        this.dispatchEvent(new CustomEvent('comments', { detail: {id : this.timeSheetRecordId, comments: this.commentsValue } }))
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Added comments successfully!.',
                    variant: 'success'
                })
            ); 
    }

}
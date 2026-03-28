import { LightningElement, track, api } from "lwc";

export default class CustomToastNotification extends LightningElement {
    @track toastList = [];
    @track toastId = 0;

    @api showToast(type, message, timeout, sticky) {
        this.toastId += 1;
        this.toastList.push({
            type: type,
            headerMessage: type,
            message: message,
            id: this.toastId,
            iconName: "utility:" + type,
            headerClass: "slds-notify slds-notify_toast slds-theme_" + type
        });

        if (sticky === false) {
            setTimeout(() => {
                this.closeModal();
            }, timeout);
        }
    }

    @api clearToasts() {
        while (this.toastId > 0) {
            this.toastId -= 1;
            this.toastList.splice(this.toastId, 1);
        }
    }

    closeModal() {
        if (this.toastId > 0) {
            this.toastId -= 1;
            this.toastList.splice(this.toastId, 1);
        }
    }

    handleClose(event) {
        let index = event.target.dataset.index;
        if (index != -1) {
            this.toastList.splice(index, 1);
            this.toastId = this.toastId - 1;
        }
    }
}
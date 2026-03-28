import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api settings = []

    value
    showErrorMessage
    errorMessage

    get disabledSave() {
        return !this.value
    }

    handleOnBlur(event) {
        this.value = event.target.value.replace(/[^A-Za-z0-9]/g, '');
    }

    handleCancel() {
        this.close('cancel');
    }

    handleSave() {
        if (this.value) {
            const existingValue = this.settings.find(setting => setting.label === this.value)
            if (!existingValue) {
                this.showErrorMessage = false
                const onSaveEvent = new CustomEvent('save', {
                    detail: {
                        appSettingName: this.value
                    }
                });
                this.dispatchEvent(onSaveEvent);
                this.close('save');
            }
            else {
                console.log('app settings name already exist')
                this.showErrorMessage = true
                this.errorMessage = "App setting name '" + this.value + "' already taken."
            }
        }
    }
}
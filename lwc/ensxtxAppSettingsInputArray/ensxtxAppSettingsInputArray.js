import { LightningElement, api, track } from 'lwc';

export default class EnsxtxAppSettingsInputArray extends LightningElement {

    values
    inputSetting

    @api showHeader
    @api
    get setting() {
        return this.inputSetting
    }
    set setting(value) {
        this.inputSetting = value
    }

    // This indicate if the input has a parent of InputMultiple
    @api isChildInput

    isEdit = false
    currentValue

    connectedCallback() {
        console.log('inputSetting value: ' + this.inputSetting)
        let inputType = this.inputSetting.type === 'integer' ? 'number' : 'text'
        this.values = this.inputSetting.value ? this.inputSetting.value.map((value, index) => {
            return {
                key: index,
                inputType: inputType,
                value: value
            }
        }) : []
    }

    handleOnFocusInput(event) {
        this.currentValue = event.target.value
    }

    handleOnBlurInput(event) {
        if (event.target.value != this.currentValue) {
            let key = event.target.name
            this.values = this.values.map(value => {
                if (value.key === key) value.value = event.target.value
                return value
            })
        }
        this.currentValue = null
    }

    handleModifyButton(event) {
        this.isEdit = !this.isEdit
    }

    handleConfirmButton(event) {
        this.createEvent()
        this.isEdit = !this.isEdit
    }

    createEvent() {
        const newSetting = {...this.inputSetting, newValue: this.values.map(value => value.value)}

        const eventName = this.isChildInput
            ? 'childinputmultiplechange'
            : 'ensxtx__settings_event'

        const settingsChanged = new CustomEvent(eventName, {
            bubbles: this.isChildInput ? false : true,
            composed: this.isChildInput ? false : true,
            detail: {
                operation: 'update',
                setting: newSetting
            }
        })

        this.dispatchEvent(settingsChanged)
    }

    handleAddValue(event) {
        let inputType = this.inputSetting.type === 'integer' ? 'number' : 'text'
        let newKey = 0;

        if (this.values.length) {
            const lastItem = this.values[this.values.length - 1]
            newKey = lastItem.key + 1
        }

        let newValue = {
            key: newKey,
            inputType: inputType,
            value: null
        }
        this.values = [...this.values, newValue]
    }

    handleDelete(event) {
        console.log('handle delete value')
        const key = event.target.name
        this.values = this.values.filter(value => value.key !== key)
    }
}
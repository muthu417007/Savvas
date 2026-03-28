import { LightningElement, api } from 'lwc';

export const buildSettingInfo = (schema, key, value, parentProp) => {
    console.log('build setting info')
    let inputType;

    switch(schema.type) {
        case 'integer':
            inputType = 'number'
            break;
        case 'string':
            inputType = 'text'
            break;
        case 'boolean':
            inputType = 'checkbox'
            break;
        case 'array':
            inputType = 'array'
            break;
        default:
            inputType = 'object'
    }

    if (schema.enum !== undefined) inputType = 'select'

    return {
        ...schema,
        name: key,
        inputType: inputType,
        inputField: inputType === 'text' || inputType === 'number',
        inputCheckbox: inputType === 'checkbox',
        inputSelect: inputType === 'select',
        inputObject: inputType === 'object' && !schema.table,
        inputMultiple: inputType === 'array',
        inputTable: schema.table,
        selectOptions: schema.enum?.map(value => ({label: value, value: value})),
        value: value,
        parentProperties: parentProp
    }
}

export default class EnsxtxAppSettingsInputTable extends LightningElement {

    inputSetting
    columns
    values
    inputValue
    errorMessage
    enableAddAndRemove

    @api
    get setting() {
        return this.inputSetting
    }
    set setting(value) {
        this.inputSetting = value
    }

    connectedCallback() {
        let inputColumns = {}
        if (this.inputSetting.patternProperties) {
            let patternProperties = this.inputSetting.patternProperties['^[A-Za-z_][A-Za-z0-9_]*$']

            if (patternProperties.properties) {
                inputColumns = {...patternProperties.properties}
            }
            if (patternProperties.items) {
                inputColumns.items = {...patternProperties.items}
            }
        }

        this.enableAddAndRemove = this.inputSetting.enableAddAndRemove

        this.inputSetting.objectSettings.forEach(obj => {
            if (obj.objectSettings) {
                obj.objectSettings.forEach(obj2 => {
                    const key = obj2.name
                    if (!inputColumns[key]) {
                        inputColumns[key] = obj.properties[key]
                    }
                })
            }
        })

        let headerColumns = {
            button: {
                title: ''
            },
            name: {
                title: 'Name',
                description: 'Name of the field',
                type: 'string'
            },
            ...inputColumns
        }

        this.columns = Object.entries(headerColumns).map(([key, value]) => ({...value, name: key}));
        console.log('columns: ' + this.columns)

        // Remove the remove column if it's not Default setting
        if (!this.enableAddAndRemove) this.columns.shift();

        this.values = this.inputSetting.objectSettings.map(obj => {
            return {...obj, cellInputs: Object.keys(inputColumns).map(column => {
                if (obj.objectSettings) {
                    let input = {name: column}
                    for (let objSetting of obj.objectSettings) {
                        if (column === objSetting.name) {
                            input = {...objSetting}
                            break
                        }
                    }
                    return input
                }
                else if (obj.inputArray) {
                    return {
                        ...obj.items,
                        inputArray: true,
                        name: obj.name,
                        value: obj.value,
                        parentProperties: obj.parentProperties
                    }
                }
            })}
        })
        console.log('values: ' + this.values)
    }

    handleInputOnBlur(event) {
        this.inputValue = event.target.value;
    }

    handleDelete(event) {
        console.log('handle delete: ' + event.target.name)
        let deletedSetting = this.values.find(value => value.name === event.target.name)
        this.values = this.values.filter(value => value.name !== event.target.name)


        const newSettingEvent = new CustomEvent('ensxtx__settings_event', {
            bubbles: true,
            composed: true,
            detail: {
                operation: 'delete',
                setting: deletedSetting
            }
        })

        this.dispatchEvent(newSettingEvent)
    }

    handleAddNewValue() {
        console.log('handle add new value: ' + this.inputValue)
        if (!this.inputValue) {
            this.errorMessage = 'Name cannot be empty'
            return
        }
        let objectSetting = this.values.find(obj => (obj.name === this.inputValue))
        if (objectSetting) {
            this.errorMessage = 'Name ' + this.inputValue + ' is already taken.'
        }
        else {
            let patternProperties = this.inputSetting.patternProperties['^[A-Za-z_][A-Za-z0-9_]*$']
            const parentProp = this.inputSetting.parentProperties + ':' + this.inputSetting.name
            let schema = {type: patternProperties.type}
            let value = patternProperties.type === 'array' ? [] : {}
            let newSetting = buildSettingInfo(schema, this.inputValue, value, parentProp)

            newSetting.cellInputs = [];

            if (patternProperties.properties) {
                let newProperties = {...patternProperties.properties}
                newSetting.cellInputs = Object.entries(newProperties).map(([key, value]) =>
                    buildSettingInfo(value, key, value.default, parentProp + ':' + this.inputValue)
                )
            }
            if (patternProperties.type === 'array') {
                let newProperties = {
                    ...patternProperties.items,
                    inputMultiple: true,
                    name: this.inputValue,
                    value: [],
                    parentProperties: parentProp
                }
                newSetting.cellInputs = [...newSetting.cellInputs, newProperties]
            }

            this.values = [...this.values, newSetting]
            this.inputValue = ''
            this.errorMessage = ''

            const newSettingEvent = new CustomEvent('ensxtx__settings_event', {
                bubbles: true,
                composed: true,
                detail: {
                    operation: 'insert',
                    setting: newSetting
                }
            })

            this.dispatchEvent(newSettingEvent)
        }
    }
}
import { LightningElement, api } from 'lwc';

export default class CustomNextFlipPopupStayEditor extends LightningElement {

    get inputVariables() {
        return this._inputVariables;
    }

    //Get input variables
    set inputVariables(variables) {
        this._inputVariables = variables || [];
    }

    // Get the value of the image input variable.
    get imageUrl() {
        const param = this.inputVariables.find(({name}) => name === 'imageUrl');
        return param && param.value;
    }

    handleChangeImage(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'imageUrl',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeVariable1(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'variable1',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeVariable2(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'variable2',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangeVariable3(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'variable3',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangeVariable4(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'variable4',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangeFontLarge(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'fontLarge',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangeFontSmall(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'fontSmall',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeFontColor(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'fontColor',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeNav(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'navLogic',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeCompLarge(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'componentTextLarge',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeCompSmall(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'componentTextSmall',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangemyHeight(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'myHeight',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangemyWidth(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'myWidth',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
    handleChangemyUrl(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'myUrl',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }

    handleChangeAriaText(event) {
        if (event && event.detail) {
            const newValue = event.detail.value;
            const valueChangedEvent = new CustomEvent(
                'configuration_editor_input_value_changed', {
                     bubbles: true,
                     cancelable: false,
                     composed: true,
                     detail: {
                         name: 'ariaText',
                         newValue,
                         newValueDataType: 'String'
                     }
                }
            );
            this.dispatchEvent(valueChangedEvent);
        }
    }
}
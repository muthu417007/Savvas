import { LightningElement, api } from 'lwc';

export default class EnsxtxAppSettingsInputHeader extends LightningElement {

    @api setting

    get showHelpText() {
        return this.setting.description ? true : false
    }
}
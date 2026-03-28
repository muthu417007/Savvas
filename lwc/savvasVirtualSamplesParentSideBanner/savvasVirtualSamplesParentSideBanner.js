import { LightningElement, api } from 'lwc';
import realizeBanner from '@salesforce/label/c.Savvas_Virtual_Samples_Savvas_Realize';
import defaultBanner from '@salesforce/label/c.Savvas_Virtual_Samples_Default';
export default class SavvasVirtualSamplesParentSideBanner extends LightningElement {

    @api programBanner;
    label = {
        realizeBanner,
        defaultBanner
    };

    get showContentV2() {
        return this.programBanner === realizeBanner;
    }

    get showContentDefault() {
        return this.programBanner === defaultBanner;
    }

    get showNoContent() {
        return this.programBanner === '';
    }

}
import { LightningElement, api } from 'lwc';
import vectorimage from '@salesforce/resourceUrl/SavvasVirtualSampleImages';

export default class SavvasVirtualSampleProgramsNavigation extends LightningElement {
    vector_icon = vectorimage + '/Images/vec_icon.png';
    @api programName;
    @api isVirtualSample;
    programs = "programs";

    renderedCallback() {
        if (this.isVirtualSample) {
            this.programs = "programs";
        }
        else {
            this.programs = "programs_2";
        }
    }
}
import { LightningElement,api} from 'lwc';
export default class ProgressIndicatorComponent extends LightningElement {
   @api stages;
   @api currentStage;
}